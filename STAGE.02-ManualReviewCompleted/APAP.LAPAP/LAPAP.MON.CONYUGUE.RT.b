* @ValidationCode : MjotMTEyNjEwNjI0OkNwMTI1MjoxNjgyMDczNzUyNTEyOkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:12:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MON.CONYUGUE.RT

*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                 REFERENCE           DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion     BP is removed in Insert File , I to I.VAR
* 21-APR-2023    Narmadha V         R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------
 
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT ;*R22 Auto conversion - END


    GOSUB INIT
    GOSUB INITb
    GOSUB PROCESS
    GOSUB END_PROCESS


INIT:
*----

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""

    customer = COMI
    CALL OPF(FN.CUS,F.CUS)

    Y.NOMBRE.CONYUGUE = ''
    Y.FECHA.NAC.CONYUGUE = ''
    Y.TEL.CONYUGUE = ''

RETURN

INITb:
*----

    CALL F.READ(FN.CUS,customer,R.CUS,F.CUS,CUS.ERR)

RETURN


PROCESS:
*-------


    Y.RELATION.CODE = R.CUS<EB.CUS.RELATION.CODE>
    Y.REL.CUSTOMER = R.CUS<EB.CUS.REL.CUSTOMER>
    Y.QNT.REL  = DCOUNT(Y.RELATION.CODE,@VM)

RETURN


END_PROCESS:
*---------------
    Y.TEL.CASA = ''
    FOR I.VAR = 1 TO Y.QNT.REL STEP 1
        IF Y.RELATION.CODE<I.VAR> EQ 7 OR Y.RELATION.CODE<I.VAR> EQ 8 THEN
            Y.CONYUGUE = Y.REL.CUSTOMER<I.VAR>
            CALL F.READ(FN.CUS,Y.CONYUGUE,R.CUS2,F.CUS,CUS2.ERR)
            Y.NOMBRE.CONYUGUE = R.CUS2<EB.CUS.NAME.1> : " " : R.CUS2<EB.CUS.NAME.2>
            Y.FECHA.NAC.CONYUGUE = R.CUS2<EB.CUS.DATE.OF.BIRTH>

            CALL GET.LOC.REF("CUSTOMER","L.CU.TEL.TYPE",POS)
            TEL.TYPE = R.CUS2<EB.CUS.LOCAL.REF,POS>
            CALL GET.LOC.REF("CUSTOMER","L.CU.TEL.AREA",POS)
            AREA = R.CUS2<EB.CUS.LOCAL.REF,POS>
            CALL GET.LOC.REF("CUSTOMER","L.CU.TEL.NO",POS)
            TEL.NO = R.CUS2<EB.CUS.LOCAL.REF,POS>
            Y.QNT.TELS = DCOUNT(TEL.TYPE, @SM)
            FOR A = 1 TO Y.QNT.TELS STEP 1
                IF TEL.TYPE<1,1,A> EQ "1" THEN
                    Y.TEL.CASA = AREA<1,1,A> : TEL.NO<1,1,A>
                END
            NEXT A
            Y.TEL.CONYUGUE = Y.TEL.CASA
            BREAK
        END
    NEXT I.VAR

    COMI = Y.NOMBRE.CONYUGUE : ">" : Y.FECHA.NAC.CONYUGUE : ">" : Y.TEL.CONYUGUE

RETURN


END
