namespace SDSApplication.Uuids;

public class UartGattUuids
{
    public static Guid[] UartGattServiceUuids { get; private set; } = new Guid[] { new Guid("6e400001-b5a3-f393-e0a9-e50e24dcca9e") };
    public static Guid UartGattServiceUuid { get; private set; } = new Guid("6e400001-b5a3-f393-e0a9-e50e24dcca9e"); 
    
    public static Guid UartGattCharacteristicReceiveId = Guid.Parse("6e400003-b5a3-f393-e0a9-e50e24dcca9e");
    
    public static Guid UartGattCharacteristicSendId = Guid.Parse("6e400002-b5a3-f393-e0a9-e50e24dcca9e");

}