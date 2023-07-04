* @ValidationCode : MjoxNTc4MDEwNzQ6Q3AxMjUyOjE2ODU5NTIyMDM1ODI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jun 2023 13:33:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.AZ.FREQ.PAY
*----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 18-05-2023   Ghayathri T          R22 Manual Conversion - changed TEM.COMI to TEMP.COMI
* 24-05-2023   Conversion Tool      R22 Auto Conversion - changed ++ to +=1
*----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.DATES

    CALL GET.LOC.REF("AZ.ACCOUNT","PAYMENT.DATE",ACC.POS)

    PAY.DATE = R.NEW(AZ.LOCAL.REF)<1,ACC.POS>

    PAY.DATE.OLD = R.OLD(AZ.LOCAL.REF)<1,ACC.POS>

    IF  PAY.DATE NE PAY.DATE.OLD  THEN

        IF PAY.DATE NE "" THEN

            IF PAY.DATE LE 31 THEN


                Y.TODAY = R.DATES(EB.DAT.TODAY)

                FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
                F.AZ.ACCOUNT = ''
                CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

                VAR.VALUE.DATE = Y.TODAY

                ACT.FREQ = R.NEW(AZ.FREQUENCY)

                IF LEN(PAY.DATE) EQ 1 THEN

                    Y.MONTH.FREQ = "M010":PAY.DATE

                END

                IF LEN(PAY.DATE) EQ 2 THEN

                    Y.MONTH.FREQ = "M01":PAY.DATE

                END

                TEMP.COMI =  COMI

                COMI = Y.TODAY:Y.MONTH.FREQ

                CALL CFQ

                Y.FREQ = COMI

                COMI = TEMP.COMI ;* R22 Manual Conversion - changed TEM.COMI to TEMP.COMI

*R.NEW(AZ.FREQUENCY) = Y.FREQ

                Y.TRANS.ID = ID.NEW

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

                R.ACC<AZ.FREQUENCY> = Y.FREQ

                CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACC,FINAL.OFS)

*CALL OFS.GLOBUS.MANAGER("AZ.MIG.PERIOD", FINAL.OFS)

                CALL OFS.POST.MESSAGE(FINAL.OFS,Y.TRANS.ID,"DM.OFS.SRC.VAL",OPTIONS)

            END

        END

    END

END
