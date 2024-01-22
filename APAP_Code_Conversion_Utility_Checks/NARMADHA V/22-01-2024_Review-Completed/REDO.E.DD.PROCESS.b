* @ValidationCode : MjotNzg4OTAxNzY5OlVURi04OjE3MDU5MDY0NTUzMDQ6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2024 12:24:15
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.DD.PROCESS(ENQ.DATA)
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.E.DD.PROCESS
* Primary Purpose : Clearing all record from the template 'REDO.W.DIRECT.DEBIT'
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* JEEVA T              31-10-2011         B.9-DIRECT DEBIT
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM and SM to @SM
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 02-01-2024         Narmadha V            Manual R22 Conversion - ID variable changed instead of hardcoding
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.W.DIRECT.DEBIT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_EB.EXTERNAL.COMMON


    Y.LIST = ''
    FN.REDO.W.DIRECT.DEBIT = 'F.REDO.W.DIRECT.DEBIT'
    F.REDO.W.DIRECT.DEBIT = ''
    CALL OPF(FN.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT)
    Y.ID = "FT" ;*Manual R22 Conversion
*CALL F.READ(FN.REDO.W.DIRECT.DEBIT,'FT',R.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT,Y.ERR)
    CALL F.READ(FN.REDO.W.DIRECT.DEBIT,Y.ID,R.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT,Y.ERR) ;*Manual R22 Conversion - ID variable changed instead of hardcoding
    Y.LIST = R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.FT.ID>

    CHANGE @VM TO ' ' IN Y.LIST
    CHANGE @SM TO ' ' IN Y.LIST
    CHANGE @FM TO ' ' IN Y.LIST

    ENQ.DATA<2,-1> ='@ID'
    ENQ.DATA<3,-1> ='EQ'
    ENQ.DATA<4,-1> = Y.LIST
RETURN
END
