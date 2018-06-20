public class HW1_P2 {
  private static byte[] cipherText = new byte[] { -119, 119, 48, -18, 29, 23, -85, 81, 22, -85, 70, 74, -66, 90, 20, -15, 66, 5, -67, 65, 19, -95, 64, 0, -13, 83, 5, -68, 86, 18, -81, 64, 15, -18, 122, 48, -102, 98, 75, -1, 28, 85, -60 };
  
  public static void main(String [] args) {
    // key may be of different length and - obviously - contain different values
    byte[] key = { 0, 0, 0, 0 };
        
    for (int i = 0; i < cipherText.length; i++) 
      System.out.print((char) (cipherText[i] ^ key[i % key.length]));
  }  
}
