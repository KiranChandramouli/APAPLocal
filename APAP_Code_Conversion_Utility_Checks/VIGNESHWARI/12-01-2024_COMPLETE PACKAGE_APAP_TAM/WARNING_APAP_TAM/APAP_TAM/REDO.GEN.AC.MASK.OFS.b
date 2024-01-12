* @ValidationCode : MjotMTg2MTE2OTQyNjpDcDEyNTI6MTcwNDk3MDI0MTc2Nzp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Jan 2024 16:20:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GEN.AC.MASK.OFS(Y.ID)
    
*--------------------------------------------------------------
* Description : This routine is to generate AC mask.
*--------------------------------------------------------------
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14.08.2011  PRABHU N       PACS00055362        INITIAL CREATION
** 10-04-2023 R22 Auto Conversion no changes
** 10-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AC.PRINT.MASK
    $INSERT I_REDO.GEN.AC.MASK.OFS.COMMON
    $INSERT I_F.REDO.AC.PRINT.MASK

    GOSUB PROCESS
RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------

*    CALL F.READ(FN.REDO.AC.PRINT.MASK,Y.ID,R.REDO.AC.PRINT.MASK,F.REDO.AC.PRINT.MASK,ERR)
    CALL F.READU(FN.REDO.AC.PRINT.MASK,Y.ID,R.REDO.AC.PRINT.MASK,F.REDO.AC.PRINT.MASK,ERR,'');* R22 UTILITY AUTO CONVERSION
    R.AC.PRINT.MASK<AC.MSK.ACCOUNT.NO> =  R.REDO.AC.PRINT.MASK<REDO.AC.ACCOUNT.NO>
    R.AC.PRINT.MASK<AC.MSK.MASK.DATE>  =  R.REDO.AC.PRINT.MASK<REDO.AC.MASK.DATE>
    R.AC.PRINT.MASK<AC.MSK.ENQ.START.DATE>=R.REDO.AC.PRINT.MASK<REDO.AC.START.DATE>
    R.AC.PRINT.MASK<AC.MSK.ENQ.END.DATE> =R.REDO.AC.PRINT.MASK<REDO.AC.END.DATE>
    R.AC.PRINT.MASK<AC.MSK.MASK> = 'YES'
    R.AC.PRINT.MASK<AC.MSK.MASK.NARRATIVE>=R.REDO.AC.PRINT.MASK<REDO.AC.MASK.NARRATIVE>
    R.AC.PRINT.MASK<AC.MSK.MATCHED.TO>   = R.REDO.AC.PRINT.MASK<REDO.AC.MATCHED.TO>
    R.AC.PRINT.MASK<AC.MSK.MATCHED.FROM> =  R.REDO.AC.PRINT.MASK<REDO.AC.MATCHED.FROM>
    APP.NAME = 'AC.PRINT.MASK'
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'AC.PRINT.MASK,OFS'
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = ''
    OFSRECORD = ''
    OFS.MSG.ID =''
    OFS.SOURCE.ID = 'REDO.AC.PRINT.MASK'
    OFS.ERR = ''
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.AC.PRINT.MASK,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

    CALL F.DELETE(FN.REDO.AC.PRINT.MASK,Y.ID)

RETURN
END
