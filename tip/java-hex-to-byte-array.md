# java hex & byte array

---

```java
import java.math.BigInteger;

String hex = new BigInteger(1, byteArray).toString(16);
byte[] byteArray = new BigInteger(hex, 16).toByteArray();
```
