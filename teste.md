# Protocolo de Acesso e Partilha de Documento

## Entidades e Chaves

- **Seller**: {K_S+, K_S-}
- **Buyer**: {K_B+, K_B-}
- **Group Owner**: {K_O+, K_O-}
- **Group Member i**: {K_Gi+, K_Gi-}

---

## Fase 1 – Criação do Documento

1. Seller gera:
   - K_AES
   - IV
   - N

2. Cifra o documento:
   - T = {Doc}_{K_AES, IV}

3. Calcula hash:
   - h = H(Doc)

4. Encapsula a chave simétrica:
   - EK_S = {K_AES}_{K_S+}
   - EK_B = {K_AES}_{K_B+}

5. Mensagem a assinar:
   - msg = h || N

6. Assinatura do Seller:
   - Sig_S = Sig_{K_S-}(msg)

7. Construção do ProtectedPackage:
   - encryptedData: T
   - iv: IV
   - encryptedKeys:
     - K_S+ → EK_S
     - K_B+ → EK_B
   - authorizedParties: [K_S+, K_B+]
   - signatures:
     - K_S+ → Sig_S
   - nonce: N
   - contentHash: h
   - encryptedSharingLog: {[]}_{K_AES}

8. Serialização e envio:
   - Seller → COP
   - POST /api/transactions

---

## Fase 2 – Acesso Direto ao Documento (Buyer)

1. Pedido do documento:
   - Buyer → COP
   - GET /api/transactions/{id}

2. Receção do ProtectedPackage

3. Recuperação de K_AES:
   - K_AES = Dec_{K_B-}(EK_B)

4. Verificação de autorização:
   - K_B+ ∈ authorizedParties

5. Decifragem do documento:
   - Doc = Dec_{K_AES}(T)

6. Verificação de integridade:
   - H(Doc) == h

7. Verificação de autenticidade:
   - Verify(K_S+, h || N, Sig_S)

---

## Fase 3 – Partilha do Documento com um Grupo

### Pré-condições

- Requester ∈ authorizedParties
- Grupo existe e é válido
- Membership obtida do Group Service

### Passos

1. Recuperar ProtectedPackage:
   - Requester → COP
   - GET /api/transactions/{id}

2. Obter membros do grupo:
   - Requester → GroupService
   - GET /api/groups/{groupId}/members

3. Resposta:
   - [{id, K_G1+}, {id, K_G2+}, …]

4. Recuperar K_AES:
   - K_AES = Dec_{K_req-}({K_AES}_{K_req+})

5. Encapsular K_AES para cada membro:
   - EK_Gi = {K_AES}_{K_Gi+}

6. Atualizar sharing log:
   - Dec_{K_AES}(encryptedSharingLog)
   - Append:
     - txId
     - sharedBy: K_req+
     - target: groupId
     - timestamp
   - Re-encrypt com K_AES

7. Submeter atualização:
   - Requester → COP
   - POST /api/transactions/{id}/share
   - Payload:
     - encryptedKeys += {K_Gi+ → EK_Gi}
     - encryptedSharingLog

---

## Fase 4 – Acesso por Membro do Grupo

1. Pedido do documento:
   - Member → COP
   - GET /api/transactions/{id}

2. Recuperação de K_AES:
   - K_AES = Dec_{K_G-}({K_AES}_{K_G+})

3. Decifragem do documento:
   - Doc = Dec_{K_AES}(T)
