* @ValidationCode : Mjo4ODg2MjMxNzQ6Q3AxMjUyOjE2ODIzMzE1NjU3NzQ6SVRTUzotMTotMTo3ODg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:49:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 788
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.BCR.TC.REPORT.POST
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - $INCLUDE T24.BP TO $INSERT, $INCLUDE TAM.BP TO $INSERT, $INCLUDE TO $INSERT
* 21.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON                         ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_EQUATE                         ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_F.DATES                        ;** R22 Auto conversion - $INCLUDE T24.BP TO $INSERT
    $INSERT I_F.REDO.INTERFACE.PARAM         ;** R22 Auto conversion - $INCLUDE TAM.BP TO $INSERT
    $INSERT JBC.h                            ;** R22 Auto conversion - $INCLUDE TO $INSERT
   $USING EB.Service


    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

INITIALISE:
**********

    FN.REDO.B.BCR.TC.WORKFILE="F.REDO.B.BCR.TC.WORKFILE"
    F.REDO.B.BCR.TC.WORKFILE=''
    CALL OPF(FN.REDO.B.BCR.TC.WORKFILE,F.REDO.B.BCR.TC.WORKFILE)

    FN.REDO.INTERFACE.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INTERFACE.PARAM = ''
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)

    Y.INT.CODE = 'BCR003'
    ERR.REDO.INTERFACE.PARAM = ''; R.REDO.INTERFACE.PARAM = ''
    CALL F.READ(FN.REDO.INTERFACE.PARAM,Y.INT.CODE,R.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM,ERR.REDO.INTERFACE.PARAM)
    yPath=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DIR.PATH>
    yPropFile=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FILE.NAME>
    YLAST.WORK = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.FILE.NAME1 = YLAST.WORK:'_':yPropFile:'.txt'

    FN.CHK.DIR = yPath
    F.CHK.DIR = ''
    CALL OPF(FN.CHK.DIR,F.CHK.DIR)
    R.FIL = '';    FIL.ERR = ''
    CALL F.READ(FN.CHK.DIR,Y.FILE.NAME1,R.FIL,F.CHK.DIR,FIL.ERR)
    IF R.FIL THEN
        DELETE F.CHK.DIR,Y.FILE.NAME1
    END
RETURN

PROCESS:
********
    SEL.CMD = ''; ID.LIST = ""; ID.CNT = ''; ERR.SEL = ''
    SEL.CMD = "SELECT ":FN.REDO.B.BCR.TC.WORKFILE
    CALL EB.READLIST(SEL.CMD, ID.LIST, "", ID.CNT, ERR.SEL)
    ID.CTR = 1
    LOOP
    WHILE ID.CTR LE ID.CNT
        R.REC = ''; RD.ERR = ''; REC.ID = ''
        REC.ID = ID.LIST<ID.CTR>
        CALL F.READ(FN.REDO.B.BCR.TC.WORKFILE, REC.ID, R.REC, F.REDO.B.BCR.TC.WORKFILE, RD.ERR)
        IF R.REC THEN
            R.FILE.DATA<-1> = R.REC
        END
        ID.CTR += 1
    REPEAT
    WRITE R.FILE.DATA ON F.CHK.DIR, Y.FILE.NAME1 ON ERROR
        CALL OCOMO("Unable to write to the file":F.CHK.DIR)
    END
*    CALL EB.CLEAR.FILE(FN.REDO.B.BCR.TC.WORKFILE,F.REDO.B.BCR.TC.WORKFILE)
EB.Service.ClearFile(FN.REDO.B.BCR.TC.WORKFILE,F.REDO.B.BCR.TC.WORKFILE);* R22 UTILITY AUTO CONVERSION
RETURN

END
