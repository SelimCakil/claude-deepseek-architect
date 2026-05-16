# Örnek Görev: Kullanıcı Yönetim Modülü

Bu dosyayı Claude'a verin — otomatik olarak analiz edip paralel görev dağıtımı yapacaktır.

## Genel Bakış

Bir kullanıcı yönetim modülü geliştireceğiz. Frontend ve backend birbirinden bağımsız olduğu için paralel geliştirilebilir.

---

## Frontend Görevleri (React/TypeScript)

- Kullanıcı listesi bileşeni (`UserList.tsx`)
- Kullanıcı ekleme formu (`UserForm.tsx`)
- Silme onay modalı (`DeleteModal.tsx`)

## Backend Görevleri (Node.js/Express)

- `GET /api/users` — tüm kullanıcıları döndür
- `POST /api/users` — yeni kullanıcı oluştur
- `DELETE /api/users/:id` — kullanıcı sil

## Veri Modeli

```typescript
interface User {
  id: string;
  name: string;
  email: string;
  role: "admin" | "user";
  createdAt: Date;
}
```

---

> Bu dosyayı Claude'a verin ve nasıl paralel dağıttığını gözlemleyin.
