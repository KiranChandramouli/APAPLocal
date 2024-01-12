* @ValidationCode : MjoxNjc4MTQ1MjQzOkNwMTI1MjoxNjgyNDEyMzI3NzE5OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.AZ.DEPOSIT.PRINT
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine will be executed at check Record Routine for the deposit versions.
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN : -NA-
* OUT : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.CHK.AZ.DEPOSIT.PRINT
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE WHO REFERENCE DESCRIPTION
* 08-11-2011 Sudharsanan S CR.18 Initial Creation.
* -----------------------------------------------------------------------------------------
*Modification History
*DATE                   WHO                       REFERENCE                    DESCRIPITION
*04-04-2023           Conversion Tool          R22 Auto Code conversion         No Changes
*04-04-2023            Samaran T                Manual R22 Code Conversion    No Changes
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT

    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
    LOC.REF = 'AZ.ACCOUNT'
    LOC.FIELD = 'L.AC.OTH.REASON'
    LOC.POS = ''
    CALL GET.LOC.REF(LOC.REF,LOC.FIELD,LOC.POS)
    POS.L.AC.OTH.REASON = LOC.POS


    R.NEW(AZ.LOCAL.REF)<1,POS.L.AC.OTH.REASON> = R.OLD(AZ.LOCAL.REF)<1,POS.L.AC.OTH.REASON>
RETURN
*---------------------------------------------------------------------------------------------------------------
END
