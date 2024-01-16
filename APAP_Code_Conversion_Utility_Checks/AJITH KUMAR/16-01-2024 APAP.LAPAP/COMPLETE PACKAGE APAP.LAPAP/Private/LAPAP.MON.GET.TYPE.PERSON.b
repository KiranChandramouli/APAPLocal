* @ValidationCode : MjoxOTEwNTY2MjY2OkNwMTI1MjoxNjg5OTE4OTQzMjYwOklUU1M6LTE6LTE6NDAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Jul 2023 11:25:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 400
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*20-07-2023    VICTORIA S          R22 MANUAL CONVERSION   Folder name removed
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.MON.GET.TYPE.PERSON

    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER ;*R22 MANUAL CONVERSION END- Folder name removed
   $USING EB.LocalReferences

*---------------------
* Defining prpierties
*---------------------

    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)


    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)

    ID = COMI

    CALL F.READ(FN.ACC,ID,R.ACC,F.ACC,ERRC)
    CUSTOMER.ID = R.ACC<AC.CUSTOMER>

    CALL F.READ(FN.CUS,CUSTOMER.ID,R.CUS,F.CUS,ERRCUS)
*    CALL GET.LOC.REF("CUSTOMER","L.CU.TIPO.CL",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.TIPO.CL",POS);* R22 UTILITY AUTO CONVERSION
    CUSTOMER.TYPE = R.CUS<EB.CUS.LOCAL.REF,POS>

    IF CUSTOMER.TYPE EQ "PERSONA FISICA" THEN
        COMI = "N"
    END ELSE
        COMI = "J"
    END

RETURN

END
