* @ValidationCode : MjotMzE0NjgyNTEzOkNwMTI1MjoxNjg0MjIyODEyODkzOklUU1M6LTE6LTE6MTc2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 176
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MON.TEL.RT
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                 REFERENCE           DESCRIPTION

* 21-APR-2023   Conversion tool   R22 Auto conversion       BP is removed in Insert File
* 21-APR-2023    Narmadha V        R22 Manual Conversion    No Changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT ;*R22 Auto conversion - END
   $USING EB.LocalReferences


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

    Y.TEL.CASA = ''
    Y.TEL.OFI = ''
    Y.TEL.CEL = ''

RETURN

INITb:
*----

    CALL F.READ(FN.CUS,customer,R.CUS,F.CUS,CUS.ERR)

RETURN


PROCESS:
*-------


*    CALL GET.LOC.REF("CUSTOMER","L.CU.TEL.TYPE",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.TEL.TYPE",POS);* R22 UTILITY AUTO CONVERSION
    TEL.TYPE = R.CUS<EB.CUS.LOCAL.REF,POS>

*    CALL GET.LOC.REF("CUSTOMER","L.CU.TEL.AREA",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.TEL.AREA",POS);* R22 UTILITY AUTO CONVERSION
    AREA = R.CUS<EB.CUS.LOCAL.REF,POS>

*    CALL GET.LOC.REF("CUSTOMER","L.CU.TEL.NO",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.TEL.NO",POS);* R22 UTILITY AUTO CONVERSION
    TEL.NO = R.CUS<EB.CUS.LOCAL.REF,POS>

    Y.QNT.TELS = DCOUNT(TEL.TYPE, @SM)

RETURN


END_PROCESS:
*---------------

    FOR A = 1 TO Y.QNT.TELS STEP 1
        IF TEL.TYPE<1,1,A> EQ "1" THEN
            Y.TEL.CASA = AREA<1,1,A> : TEL.NO<1,1,A>
        END
        IF TEL.TYPE<1,1,A> EQ "5" THEN
            Y.TEL.OFI = AREA<1,1,A> : TEL.NO<1,1,A>
        END
        IF TEL.TYPE<1,1,A> EQ "6" THEN
            Y.TEL.CEL = AREA<1,1,A> : TEL.NO<1,1,A>
        END
    NEXT A

    COMI = Y.TEL.CASA : "|" : Y.TEL.OFI : "|" : Y.TEL.CEL

RETURN


END
