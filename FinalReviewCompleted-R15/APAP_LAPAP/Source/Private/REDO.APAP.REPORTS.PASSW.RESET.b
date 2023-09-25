* @ValidationCode : MjotNTY5MDQwMjQ0OkNwMTI1MjoxNjkwMTY3NTU2ODg2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion           FM TO @FM, VM TO @VM,F.READ TO CACHE.READ, INCLUDE TO INSERT, BP removed in INSERT file
*13/07/2023      Suresh                     R22 Manual Conversion         Variable initialised
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.APAP.REPORTS.PASSW.RESET

    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_TSA.COMMON
    $INSERT I_F.REDO.APAP.USER.PASSW.PARAM ;*R22 Auto Conversion - End

    GOSUB INIT
    GOSUB PROCESS
RETURN
 
INIT:
*****
    FN.USER = 'F.USER'; F.USER = ''
    CALL OPF(FN.USER,F.USER)
    FN.REDO.APAP.PASSW.RESET = 'F.REDO.APAP.USER.PASSW.PARAM'; F.REDO.APAP.PASSW.RESET = ''
    CALL OPF(FN.REDO.APAP.PASSW.RESET,F.REDO.APAP.PASSW.RESET)
    YSERVER.NAME = SERVER.NAME
    YRPT.SERV.NME = ''
RETURN

PROCESS:
********
    ERR.REDO.APAP.PASSW.RESET = ''; R.REDO.APAP.PASSW.RESET = ''
    CALL CACHE.READ(FN.REDO.APAP.PASSW.RESET,'SYSTEM',R.REDO.APAP.PASSW.RESET,ERR.REDO.APAP.PASSW.RESET)
    YRPT.USER.ID = R.REDO.APAP.PASSW.RESET<REDO.USER.PARM.REPORT.USER>
    REDO.USER.PARM.USER.MENU="" ;*R22 Manual Conversion
    YRPT.USER.MENU = R.REDO.APAP.PASSW.RESET<REDO.USER.PARM.USER.MENU>
    REDO.USER.PARM.USER.SMS.GRP="" ;*R22 Manual Conversion
    YRPT.USER.SMS = R.REDO.APAP.PASSW.RESET<REDO.USER.PARM.USER.SMS.GRP>
    REDO.USER.PARM.SERVER.NAME="" ;*R22 Manual Conversion
    YRPT.SERV.NME = R.REDO.APAP.PASSW.RESET<REDO.USER.PARM.SERVER.NAME>
    IF YRPT.SERV.NME NE YSERVER.NAME THEN
        PRINT "Nombre del servidor que faltan"
        RETURN
    END

    YUSER.REC = YRPT.USER.ID
    CHANGE @VM TO @FM IN YRPT.USER.ID
    ERR.REDO.APAP.PASSW.RESET = ''; R.REDO.APAP.PASSW.RESET = ''
    CALL CACHE.READ(FN.REDO.APAP.PASSW.RESET,'SYSTEM',R.REDO.APAP.PASSW.RESET,ERR.REDO.APAP.PASSW.RESET)
    SEL.ERR =''; SEL.REC = ''; SEL.CNT = ''
    SEL.CMD = "SSELECT ":FN.USER
    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.CNT,SEL.ERR)
    LOOP
        REMOVE SEL.ID FROM SEL.REC SETTING SPOSN
    WHILE SEL.ID:SPOSN
        ERR.USER = ''; R.USER = ''
        CALL CACHE.READ(FN.USER, SEL.ID, R.USER, ERR.USER) ;*R22 Auto Conversion
        YRPT.MENU.VAL = ''; YRPT.USERSMS.VAL = ''
        LOCATE SEL.ID IN YRPT.USER.ID SETTING POSN THEN
            YRPT.MENU.VAL = YRPT.USER.MENU<1,POSN>
            YRPT.USERSMS.VAL = YRPT.USER.SMS<1,POSN>

            IF YRPT.MENU.VAL THEN
                R.USER<EB.USE.INIT.APPLICATION> = "?":YRPT.MENU.VAL
            END ELSE
                PRINT "Menú faltante en el parámetro ":SEL.ID
            END
            IF YRPT.USERSMS.VAL THEN
                R.USER<EB.USE.APPLICATION> = "@":YRPT.USERSMS.VAL
            END ELSE
                R.USER<EB.USE.FUNCTION> = "S L"
                PRINT "El permiso que falta en el parámetro ":SEL.ID
            END
            IF NOT(YRPT.MENU.VAL) AND NOT(YRPT.USERSMS.VAL) THEN
                ER<EB.USE.END.TIME> = '0002'
            END
        END ELSE
            R.USER<EB.USE.END.TIME> = '0002'
        END
        CALL F.WRITE(FN.USER,SEL.ID,R.USER)
        CALL JOURNAL.UPDATE('')
    REPEAT
    PRINT "Listo"
RETURN
END
