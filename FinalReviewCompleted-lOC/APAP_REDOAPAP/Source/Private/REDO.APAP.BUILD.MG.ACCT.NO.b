* @ValidationCode : MjotMTQ2ODA5NjE4NjpDcDEyNTI6MTY4MTIxNDQ0NjAwMTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 17:30:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.BUILD.MG.ACCT.NO(ENQ.DATA)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.BUILD.MG.ACCT.NO
* ODR NO : ODR-2009-10-0346
*----------------------------------------------------------------------
*DESCRIPTION: REDO.APAP.NOFILE.MG.ACCT.NO is a build routine used
* for the enquiry REDO.APAP.ENQ.MG.ACCT.NO




*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.APAP.ENQ.MG.ACCT.NO

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*27.07.2010 H GANESH ODR-2009-10-0346 INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_ENQUIRY.COMMON



    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------
GET.LOCAL.REF:
*----------------------------------------------------------------------
    LOC.REF.APPLICATION="AZ.ACCOUNT"
    LOC.REF.FIELDS='L.VAL.MAT.DATE'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.VAL.MAT.DATE=LOC.REF.POS<1,1>
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

*IF APPLICATION EQ 'AZ.ACCOUNT' THEN
*END
*IF APPLICATION EQ 'REDO.H.AZ.REINV.DEPOSIT' THEN
*ENQ.DATA<4,1>=R.NEW(REDO.AZ.REINV.VAL.MAT.DATE)
*END

    GOSUB GET.LOCAL.REF
    ENQ.DATA<4,1>=R.NEW(AZ.LOCAL.REF)<1,POS.L.VAL.MAT.DATE>
    ENQ.DATA<2,1>='TENOR.DATE'
    ENQ.DATA<3,1>='EQ'

RETURN

END
