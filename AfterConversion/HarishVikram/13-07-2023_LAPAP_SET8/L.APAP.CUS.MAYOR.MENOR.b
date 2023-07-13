* @ValidationCode : MjotMTQ5MTAzMjIxNTpDcDEyNTI6MTY4OTI0MjE3MDk4MjpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:26:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CUS.MAYOR.MENOR(CUSTOMER.ID)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       >= to GE, = to EQ, > to GT, BP Removed in INSERTFILE
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON                                ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_L.APAP.CUS.MAYOR.MENOR.COMMON          ;*R22 Auto conversion - End


    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERROR)

    FECHA.NACIMIENTO.CLI =  R.CUSTOMER<EB.CUS.DATE.OF.BIRTH>

    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',L.CU.TIPO.CL.POS)

    TIPO.CLI = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>

    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERROR)


    IF TIPO.CLI EQ 'CLIENTE MENOR' THEN

        Y.YEAR.DIFF = TODAY[1,4] - FECHA.NACIMIENTO.CLI [1,4]
        Y.MONTH.DIFF = TODAY[5,2] - FECHA.NACIMIENTO.CLI [5,2]
        Y.DATE.DIFF = TODAY[7,2] - FECHA.NACIMIENTO.CLI [7,2]

        IF Y.YEAR.DIFF GE 18 THEN

            IF Y.YEAR.DIFF EQ 18 THEN

                IF Y.MONTH.DIFF GT 0 THEN

                    GOSUB UPDATECUST

                    RETURN

                END

                IF Y.MONTH.DIFF EQ 0 THEN

                    IF  Y.DATE.DIFF GE 0 THEN

                        GOSUB UPDATECUST

                        RETURN

                    END

                END

                RETURN

            END

            GOSUB UPDATECUST

            RETURN

        END

    END

RETURN

UPDATECUST:

    Y.TRANS.ID = ""
    Y.APP.NAME = "CUSTOMER"
    Y.VER.NAME = Y.APP.NAME :",MB.DM.LOAD"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""
    R.CUSTOMER = ""

    R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS> = 'PERSONA FISICA'

    CALL OCOMO('CLIENTE MODIFICADO ' :  CUSTOMER.ID)

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,CUSTOMER.ID,R.CUSTOMER,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"DM.OFS.SRC.VAL",'')

RETURN

END
