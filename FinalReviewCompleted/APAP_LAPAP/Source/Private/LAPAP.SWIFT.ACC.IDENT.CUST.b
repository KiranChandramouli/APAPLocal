* @ValidationCode : MjoxNjM1MDk0NDMyOkNwMTI1MjoxNjg0MjIyODE1ODYwOklUU1M6LTE6LTE6NTgyOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 582
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.SWIFT.ACC.IDENT.CUST(Y.FINAL)

*--------------------------------------------------------------------------------------------------
* Description           : Enquiry NOFILE retorna la identificacion del cliente de acuerdo al # de cuenta.
* Developed On          : 16/07/2021
* Developed By          : Oliver Fermin
* Development Reference : DIP-28 - https://apap-software.atlassian.net/browse/DIP-28
* Enquiry: ENQ.SWIFT.ACC.IDENT.CUST
*--------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ALTERNATE.ACCOUNT     ;*R22 AUTO CODE CONVERSION.END

    GOSUB LOAD.TABLES
    GOSUB PROCESS

RETURN

LOAD.TABLES:
************

    FN.CUS   = "F.CUSTOMER"; F.CUS   = ""; R.CUS    = ""; CUS.ERR  = "";
    CALL OPF(FN.CUS,F.CUS)

    FN.ACC  = "F.ACCOUNT";
    FV.ACC  = "";
    R.ACC   = "";
    ACC.ERR = "";
    CALL OPF(FN.ACC,FV.ACC)

    FN.ALT.ACC  = "F.ALTERNATE.ACCOUNT";
    FV.ALT.ACC  = "";
    R.ALT.ACC   = "";
    ACC.ALT.ERR = "";
    CALL OPF(FN.ALT.ACC,FV.ALT.ACC)

RETURN

PROCESS:
********

    Y.NUMBER.PRODUCT = '';
    Y.CUSTOMER = '';

    FINDSTR 'NUMERO.PRODUCTO' IN D.FIELDS SETTING V.FLD, V.VAL THEN

        Y.NUMBER.PRODUCT = D.RANGE.AND.VALUE<V.FLD>

        IF LEFT(Y.NUMBER.PRODUCT,1) NE 1 AND LEN (Y.NUMBER.PRODUCT) GT 10 THEN
            CALL F.READ(FN.ALT.ACC,Y.NUMBER.PRODUCT,R.ALT.ACC, FV.ALT.ACC, ACC.ALT.ERR)
            Y.ALT.ACCOUNT   = R.ALT.ACC<AAC.GLOBUS.ACCT.NUMBER>

            IF Y.ALT.ACCOUNT NE "" THEN
                Y.NUMBER.PRODUCT = Y.ALT.ACCOUNT
            END
        END


        IF Y.NUMBER.PRODUCT NE '' THEN

            CALL F.READ(FN.ACC,Y.NUMBER.PRODUCT,R.ACC, FV.ACC, ACC.ERR)

            CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS1",ACC.STATUS.POS)
            L.AC.STATUS1  = R.ACC<AC.LOCAL.REF,ACC.STATUS.POS>

            Y.RECORD.STATUS      = R.ACC<AC.RECORD.STATUS>
            Y.CUSTOMER           = R.ACC<AC.CUSTOMER>

            IF Y.RECORD.STATUS EQ "CLOSED" OR L.AC.STATUS1 EQ 'CLOSED' THEN
                T.CONTINUE.FLAG  = "YES";
            END ELSE
                T.CONTINUE.FLAG = 'NO';
                GOSUB GET.IDENTIFICATION.CUSTOMER
            END

        END

    END

RETURN


GET.IDENTIFICATION.CUSTOMER:
***************************

    Y.IDENTIFICACION = '';

    CALL F.READ(FN.CUS,Y.CUSTOMER,R.CUS,F.CUS,CUS.ERR)

    IF R.CUS NE '' THEN

        CALL GET.LOC.REF("CUSTOMER","L.CU.CIDENT",POS.CIDENT)
        CEDULA = R.CUS<EB.CUS.LOCAL.REF,POS.CIDENT>

        CALL GET.LOC.REF("CUSTOMER","L.CU.RNC",POS.RNC)
        RNC.NO = R.CUS<EB.CUS.LOCAL.REF,POS.RNC>

        CALL GET.LOC.REF("CUSTOMER","L.CU.PASS.NAT",POS.NAT)
        PASS.NO = R.CUS<EB.CUS.LOCAL.REF,POS.NAT>

        CALL GET.LOC.REF("CUSTOMER","L.CU.NOUNICO",POS.NOUNICO)
        NO.UNIC = R.CUS<EB.CUS.LOCAL.REF,POS.NOUNICO>

        CALL GET.LOC.REF("CUSTOMER","L.CU.ACTANAC",POS.ACTANAC)
        B.CERT = R.CUS<EB.CUS.LOCAL.REF,POS.ACTANAC>

        BEGIN CASE
            CASE CEDULA NE ''
                Y.IDENTIFICACION = CEDULA[1,3]:'-':CEDULA[4,7]:'-':CEDULA[11,1]
            CASE RNC.NO NE ''
                Y.IDENTIFICACION  = RNC.NO[1,1]:'-':RNC.NO[2,2]:'-':RNC.NO[4,5]:'-':RNC.NO[9,1]
            CASE PASS.NO  NE ''
                Y.IDENTIFICACION = PASS.NO
            CASE NO.UNIC  NE ''
                Y.IDENTIFICACION = NO.UNIC
            CASE B.CERT  NE ''
                Y.IDENTIFICACION = B.CERT
        END CASE


        IF T.CONTINUE.FLAG EQ "NO" AND Y.IDENTIFICACION '' THEN
            Y.FINAL<-1> = Y.CUSTOMER:"*":Y.IDENTIFICACION;
        END

    END

RETURN
