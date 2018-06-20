import javax.crypto.Cipher;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.BadPaddingException;
import java.security.MessageDigest;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class HW2_solution {
    static void P1() throws Exception {
        byte[] iv = new byte[] { 0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0 };
        byte[] key = Files.readAllBytes(Paths.get("P1_key"));
        byte[] cipherText = Files.readAllBytes(Paths.get("P1_cipher.txt"));

        // BEGIN SOLUTION
        byte[] plainText = cipherText;
        SecretKeySpec keySpec = new SecretKeySpec(key, "AES");
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance("AES/CBC/ISO10126Padding");
        cipher.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);
        plainText = cipher.doFinal(plainText);
        // END SOLUTION

        System.out.println(new String(plainText, StandardCharsets.UTF_8));
    }

    static void P2() throws Exception {
        byte[] cipherBMP = Files.readAllBytes(Paths.get("P2_cipher.bmp"));

        // BEGIN SOLUTION
        byte[] P1_plaintext = "The quick brown fox jumps over the lazy dog.".getBytes(StandardCharsets.UTF_8);
        byte[] plainBMP = cipherBMP;
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(P1_plaintext);
        Cipher cipher = Cipher.getInstance("AES/ECB/ISO10126Padding");
        SecretKeySpec key = new SecretKeySpec(md.digest(), "AES");
        cipher.init(Cipher.DECRYPT_MODE, key);
        plainBMP = cipher.doFinal(plainBMP);
        // END SOLUTION

        Files.write(Paths.get("P2_plain.bmp"), plainBMP);
    }

    static void P3() throws Exception {
        byte[] cipherBMP = Files.readAllBytes(Paths.get("P3_cipher.bmp"));

        // BEGIN SOLUTION
        byte[] modifiedBMP = cipherBMP;
        byte[] P2_plaintext = Files.readAllBytes(Paths.get("P2_plain.bmp"));
        System.arraycopy(P2_plaintext, 0, modifiedBMP, 0, 2000);
        // END SOLUTION

        Files.write(Paths.get("P3_cipher_modified.bmp"), modifiedBMP);
    }

    static void P4() throws Exception {
        byte[] iv = new byte[] { 0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0,
                0, 0, 0, 0 };
        byte[] cipherBMP = Files.readAllBytes(Paths.get("P4_cipher.bmp"));

        // BEGIN SOLUTION
        byte hour = 0;
        byte minute = 0;
        byte second = 0;
        byte[] key = new byte[] {   65,   6,    39,   69,
                115,   hour, minute, second,
                0,   0,    0,   0,
                0,   0,    0,   0 };
        byte[] plainBMP = cipherBMP;
        byte[] P2_plaintext = Files.readAllBytes(Paths.get("P2_plain.bmp"));
        byte[] check = new byte[] { 0, 0, 0, 0, 0, 0};
        boolean flag = false;
        System.arraycopy(P2_plaintext, 0, check, 0, 6);
        SecretKeySpec keySpec;
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance("AES/CBC/ISO10126Padding");
        for(int i = 0; i < 86400; i++)
        {
            hour = (byte) (i / 3600);
            minute = (byte) ((i % 3600) / 60 );
            second = (byte) (i % 60);
            key[5] = hour;
            key[6] = minute;
            key[7] = second;
            try{
                keySpec = new SecretKeySpec(key, "AES");
                cipher.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);
                plainBMP = cipher.doFinal(plainBMP);
                for(int j = 0; j < 6; j++){
                    if(check[j] != plainBMP[j]) { break; }
                    else if(j == 5) { flag = true; }
                }
                if(flag) { break; }
                else{
                    keySpec = null;
                    plainBMP = cipherBMP;
                }
            }
            catch (BadPaddingException e){

            }
        }
        // END SOLUTION

        Files.write(Paths.get("P4_plain.bmp"), plainBMP);
    }

    public static void main(String [] args) {
        try {
            P1();
            P2();
            P3();
            P4();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
