* @ValidationCode : MjoxNTE3MDI1NDgxOlVURi04OjE2ODkyNTQ1MTcyMDE6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jul 2023 18:51:57
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
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MOVE.NCF.RT
*-----------------------------------------------------------------------------
* Modification History
* DATE               AUTHOR              REFERENCE              DESCRIPTION
* 13-07-2023    Conversion Tool        R22 Auto Conversion     BP is removed in insert file,FM to @FM
* 13-07-2023    Narmadha V             R22 Manual Conversion   No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto Conversion -START
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_MOVE.NCF.COMMON ;*R22 Auto Conversion -END

    GOSUB INI
    GOSUB PROCESS


INI:
    FN.REDO.AA.NCF.IDS = 'F.REDO.AA.NCF.IDS'
    F.REDO.AA.NCF.IDS = ''
    CALL OPF(FN.REDO.AA.NCF.IDS,F.REDO.AA.NCF.IDS)

    FN.USER='F.USER'
    F.USER=''
    CALL OPF(FN.USER,F.USER)

RETURN

PROCESS:
    TO.ID= 'OTHERS.499'
    CALL F.READU(FN.REDO.AA.NCF.IDS,TO.ID,R.REDO.AA.NCF.IDS.TO,F.REDO.AA.NCF.IDS,R.REDO.AA.NCF.IDS.ERR.TO,RETRY.VAR)
    SEL.CMD = "SELECT ":FN.USER:" WITH APPLICATION LIKE ...CAJA... AND END.DATE.PROFILE LT " : TODAY
    CALL EB.READLIST(SEL.CMD,CHANGE.LIST,'',NO.REC,PGM.ERR)

    LOOP
        REMOVE Y.USER.ID FROM CHANGE.LIST SETTING TEMP.POS
    WHILE Y.USER.ID
        CALL F.READ(FN.REDO.AA.NCF.IDS,Y.USER.ID,R.REDO.AA.NCF.IDS.FROM,F.REDO.AA.NCF.IDS,R.REDO.AA.NCF.IDS.ERR.FROM)

        IF R.REDO.AA.NCF.IDS.TO EQ '' THEN
            R.REDO.AA.NCF.IDS.TO=R.REDO.AA.NCF.IDS.FROM
        END ELSE
            CALL OCOMO("TRANSFIRIENDO DESDE :" : Y.USER.ID : " HACIA: " : TO.ID)
            R.REDO.AA.NCF.IDS.TO=R.REDO.AA.NCF.IDS.TO:@FM:R.REDO.AA.NCF.IDS.FROM
        END
        CALL OCOMO("ELIMINANDO :" : Y.USER.ID)
        CALL F.DELETE(FN.REDO.AA.NCF.IDS,Y.USER.ID)
    REPEAT
    CALL F.WRITE(FN.REDO.AA.NCF.IDS,TO.ID,R.REDO.AA.NCF.IDS.TO)
    CALL JOURNAL.UPDATE('FROM.ID')
RETURN

END
