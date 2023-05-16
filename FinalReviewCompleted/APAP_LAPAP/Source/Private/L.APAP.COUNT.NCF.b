* @ValidationCode : MjotMTYwMzIzOTU3NjpDcDEyNTI6MTY4MjMzMTMyMDUzNDpJVFNTOi0xOi0xOjc5ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 798
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
PROGRAM L.APAP.COUNT.NCF
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       FM to @FM, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion
    $INSERT I_EQUATE ;*R22 Auto conversion
    CRT @(-1)
    CRT "TOTAL DE NCF:"
*MSLEEP 400
    FN.NCF.IDS = 'F.REDO.AA.NCF.IDS'; F.NCF.IDS = ''
    CALL OPF(FN.NCF.IDS,F.NCF.IDS)
    R.FILE.DATA = ''
    Y.SUMATORIA = 0
    SEL.CMD = "SELECT ":FN.NCF.IDS : " WITH @ID NE OTHERS.500 AND @ID LIKE OTHERS... BY-DSND @ID"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST SETTING TEMP.POS
    WHILE Y.TEMP.ID
        R.REDO.REPORT.TEMP = '';        TEMP.ERR = ''
        CALL F.READ(FN.NCF.IDS,Y.TEMP.ID,R.NCF.IDS,F.NCF.IDS,TEMP.ERR)
        IF R.NCF.IDS THEN
            R.FILE.DATA<-1> = R.NCF.IDS
            CNT.ACTUAL = DCOUNT(R.NCF.IDS,@FM)
            CRT "ID: " : Y.TEMP.ID : ", QUANTITY: " : CNT.ACTUAL
            Y.SUMATORIA += CNT.ACTUAL
*DEBUG
        END
    REPEAT
    CRT "---------------------------------------"
    CRT "SUMATORIA DE CANTIDADES DE NCFS : " : Y.SUMATORIA
    CRT "---------------------------------------"

END
