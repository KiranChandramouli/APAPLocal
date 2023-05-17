SUBROUTINE REDO.APAP.SEL.CR.TELLER
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.SEL.CR
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       : Enquiry REDO.INVESTMENT.REINVESTMENT.R94
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 13 August 2010      Jeyachandran S       ODR-2010-03-0094 103         Initial Creation
* 30 March 2013       Arundev KR           PACS00260039                 T24 date format , comma delimiter
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para


    Y.CRITERIA = ''
    Y.DATE = FIELD(O.DATA,'*',1)
    Y.TELLER.REF = FIELD(O.DATA,'*',2)
    Y.TELLER.ID.REF = FIELD(O.DATA,'*',3)
    Y.CURRENCY = FIELD(O.DATA,'*',4)
    Y.TELLER.TXN.REF = FIELD(O.DATA,'*',5)


    IF Y.DATE THEN
*       Y.DATE1 = "20":Y.DATE[1,6]
*       Y.DATE2 = "20":Y.DATE[12,17]
*       Y.DATE3 = Y.DATE2[1,8]
        Y.DATE1 = Y.DATE[1,8]
        Y.DATE2 = Y.DATE[10,8]

*        Y.DATE = Y.DATE1:'*':Y.DATE2

*PACS00260039-start
*converting date into T24 date format
*       Y.DATE1 = FIELD(Y.DATE,"*",1)
*      Y.DATE1 = ICONV(Y.DATE1,"DJ")
*     Y.DATE1 = OCONV(Y.DATE1,"D4E")

*    Y.DATE2 = FIELD(Y.DATE,"*",2)
*   Y.DATE2 = TRIM(Y.DATE2)
*  Y.DATE2 = ICONV(Y.DATE2,"DJ")
* Y.DATE2 = OCONV(Y.DATE2,"D4E")

        CALL EB.DATE.FORMAT.DISPLAY(Y.DATE1,Y.DATE1.FMT,'','')
        CALL EB.DATE.FORMAT.DISPLAY(Y.DATE2,Y.DATE2.FMT,'','')
        Y.DATE = Y.DATE1.FMT:' ':Y.DATE2.FMT

*PACS00260039-end
    END

*PACS00260039-start
*IF Y.DATE THEN
*Y.CRITERIA = 'FECHA - ':Y.DATE:' '
*END

*IF Y.INS.TYPE THEN
*Y.CRITERIA := 'TIPO DE INVERSION - ':Y.INS.TYPE:' '
*END

*IF Y.CMPNY.CODE THEN
*Y.CRITERIA := 'AGENCIA - ':Y.CMPNY.CODE:' '
*END

    BEGIN CASE
        CASE Y.TELLER.REF NE '' AND Y.TELLER.ID.REF EQ '' AND Y.CURRENCY EQ '' AND Y.TELLER.TXN.REF EQ ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'REFERENCIA TXN - ':Y.TELLER.REF
        CASE Y.TELLER.REF EQ '' AND Y.TELLER.ID.REF NE '' AND Y.CURRENCY EQ '' AND Y.TELLER.TXN.REF EQ ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'NUMERO DE CAJA - ':Y.TELLER.ID.REF
        CASE Y.TELLER.REF EQ '' AND Y.TELLER.ID.REF EQ '' AND Y.CURRENCY NE '' AND Y.TELLER.TXN.REF EQ ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'MONEDA - ':Y.CURRENCY
        CASE Y.TELLER.REF EQ '' AND Y.TELLER.ID.REF EQ '' AND Y.CURRENCY EQ '' AND Y.TELLER.TXN.REF NE ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'TIPO DE TRANSACCION - ':Y.TELLER.TXN.REF

        CASE Y.TELLER.REF NE '' AND Y.TELLER.ID.REF NE '' AND Y.CURRENCY EQ '' AND Y.TELLER.TXN.REF EQ ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'REFERENCIA TXN - ':Y.TELLER.REF:',':'NUMERO DE CAJA - ':Y.TELLER.ID.REF
        CASE Y.TELLER.REF NE '' AND Y.TELLER.ID.REF EQ '' AND Y.CURRENCY NE '' AND Y.TELLER.TXN.REF EQ ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'REFERENCIA TXN - ':Y.TELLER.REF:',':'MONEDA - ':Y.CURRENCY
        CASE Y.TELLER.REF NE '' AND Y.TELLER.ID.REF EQ '' AND Y.CURRENCY EQ '' AND Y.TELLER.TXN.REF NE ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'REFERENCIA TXN - ':Y.TELLER.REF:',':'TIPO DE TRANSACCION - ':Y.TELLER.TXN.REF
        CASE Y.TELLER.REF EQ '' AND Y.TELLER.ID.REF EQ '' AND Y.CURRENCY NE '' AND Y.TELLER.TXN.REF NE ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'MONEDA - ':Y.CURRENCY:',':'TIPO DE TRANSACCION - ':Y.TELLER.TXN.REF

        CASE Y.TELLER.REF NE '' AND Y.TELLER.ID.REF NE '' AND Y.CURRENCY NE '' AND Y.TELLER.TXN.REF EQ ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'REFERENCIA TXN - ':Y.TELLER.REF:',':'NUMERO DE CAJA - ':Y.TELLER.ID.REF:','::'MONEDA - ':Y.CURRENCY
        CASE Y.TELLER.REF NE '' AND Y.TELLER.ID.REF EQ '' AND Y.CURRENCY NE '' AND Y.TELLER.TXN.REF NE ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'REFERENCIA TXN - ':Y.TELLER.REF:',':'MONEDA - ':Y.CURRENCY:',':'TIPO DE TRANSACCION - ':Y.TELLER.TXN.REF
        CASE Y.TELLER.REF NE '' AND Y.TELLER.ID.REF NE '' AND Y.CURRENCY EQ '' AND Y.TELLER.TXN.REF NE ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'REFERENCIA TXN - ':Y.TELLER.REF',':'NUMERO DE CAJA - ':Y.TELLER.ID.REF:',':'TIPO DE TRANSACCION - ':Y.TELLER.TXN.REF
        CASE Y.TELLER.REF EQ '' AND Y.TELLER.ID.REF NE '' AND Y.CURRENCY NE '' AND Y.TELLER.TXN.REF NE ''
            Y.CRITERIA = 'FECHA - ':Y.DATE:',':'NUMERO DE CAJA - ':Y.TELLER.ID.REF:',':'MONEDA - ':Y.CURRENCY:',':'TIPO DE TRANSACCION - ':Y.TELLER.TXN.REF

        CASE 1
            Y.CRITERIA = 'FECHA - ':Y.DATE
    END CASE
*PACS00260039-end

    O.DATA = Y.CRITERIA

RETURN

*--------------------------------------------------------------------------------------------------------
END       ;* End of program
