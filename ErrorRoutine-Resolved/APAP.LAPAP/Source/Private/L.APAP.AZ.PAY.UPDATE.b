* @ValidationCode : MjotMjc1OTExNDg5OkNwMTI1MjoxNjg0OTEyNzI5NDQ5OmhhaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 May 2023 12:48:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.AZ.PAY.UPDATE
*----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 18-05-2023   Ghayathri T          R22 Manual Conversion - changed TEM.COMI to TEMP.COMI
* 24-05-2023   Conversion Tool      R22 Auto Conversion - changed = to EQ
*----------------------------------------------------------------------------


    $INSERT I_COMMON

    $INSERT I_EQUATE

    $INSERT I_F.AZ.ACCOUNT

    $INSERT I_F.DATES

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    Y.TODAY = R.DATES(EB.DAT.TODAY)

    SELECT.STATEMENT = 'SELECT ':FN.AZ.ACCOUNT
    AZ.ACCOUNT.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,AZ.ACCOUNT.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    LOOP
        REMOVE AZ.ACCOUNT.ID FROM AZ.ACCOUNT.LIST SETTING AZ.ACCOUNT.MARK
    WHILE AZ.ACCOUNT.ID : AZ.ACCOUNT.MARK

        R.AZ.ACCOUNT = ''
        YERR = ''
        CALL F.READ(FN.AZ.ACCOUNT,AZ.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,YERR)

        Y.TRANS.ID = AZ.ACCOUNT.ID

        Y.VER.NAME = "AZ.ACCOUNT,OFS"

        Y.APP.NAME = "AZ.ACCOUNT"

        Y.FUNC = "I"

        Y.PRO.VAL = "PROCESS"

        Y.GTS.CONTROL = ""

        Y.NO.OF.AUTH = ""

        FINAL.OFS = ""

        OPTIONS = ""

        Y.CAN.NUM = 0

        Y.CAN.MULT = ""

        R.ACC = ""

        AZ.FREQ = R.AZ.ACCOUNT<AZ.FREQUENCY>

        IF LEN(AZ.FREQ) EQ 8 THEN

            PAY.DATE = AZ.FREQ[7,2]

        END

        IF LEN(AZ.FREQ) EQ 13 THEN

            PAY.DATE = AZ.FREQ[12,2]

        END

        CALL GET.LOC.REF("AZ.ACCOUNT","PAYMENT.DATE",ACC.POS)

        CALL GET.LOC.REF("AZ.ACCOUNT","L.AZ.REF.NO",ACC.POS.REF)

        AZ.REF.NO = R.AZ.ACCOUNT<AZ.LOCAL.REF,ACC.POS.REF>

        AZ.DATE = Y.TODAY

        IF AZ.REF.NO[1,2] EQ 'AZ' THEN

            R.ACC<AZ.LOCAL.REF,ACC.POS> = 30

            CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACC,FINAL.OFS)

            CALL OFS.GLOBUS.MANAGER("AZ.MIG.PERIOD", FINAL.OFS)

        END ELSE


            IF LEN(PAY.DATE) EQ 1 THEN

                Y.MONTH.FREQ = "M010":PAY.DATE

            END

            IF LEN(PAY.DATE) EQ 2 THEN

                Y.MONTH.FREQ = "M01":PAY.DATE

            END

            TEMP.COMI =  COMI

            COMI = AZ.DATE:Y.MONTH.FREQ

            CALL CFQ

            Y.FREQ = COMI

            COMI = TEMP.COMI;* R22 Manual Conversion - changed TEM.COMI to TEMP.COMI

            R.ACC<AZ.FREQUENCY> = Y.FREQ

            R.ACC<AZ.LOCAL.REF,ACC.POS> = PAY.DATE

            CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACC,FINAL.OFS)

            CALL OFS.GLOBUS.MANAGER("AZ.MIG.PERIOD", FINAL.OFS)

        END



    REPEAT


END
