$PACKAGE APAP.LAPAP
* @ValidationCode : MjoxNTA0OTk2MzE6Q3AxMjUyOjE2ODkyNDMwOTQ2MTU6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 15:41:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.DEMO.CH.DATE.PEND

    $INSERT I_COMMON                          ;*R22 Auto conversion - Start
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ST.LAPAP.MOD.DIRECCIONES       ;*R22 Auto conversion - End

    FN.ST.LAPAP.MOD.DIRECCIONES = "F.ST.LAPAP.MOD.DIRECCIONES"
    ST.LAPAP.MOD.DIRECCIONES = ""
    CALL OPF(FN.ST.LAPAP.MOD.DIRECCIONES,F.ST.LAPAP.MOD.DIRECCIONES)

    Y.VALUE.IDENT = O.DATA


    SELECT.STATEMENT = "SELECT FBNK.ST.LAPAP.MOD.DIRECCIONES WITH CLIENTE EQ " : Y.VALUE.IDENT : " AND ESTADO EQ PENDIENTE "

    Y.REDO.LOAN.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.TYPE.PRODUCT = ''
    CALL EB.READLIST(SELECT.STATEMENT,Y.REDO.DIR.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    LOOP
        REMOVE Y.ENTY.ID FROM Y.REDO.DIR.LIST SETTING POS
    WHILE Y.ENTY.ID:POS

        CALL F.READ(FN.ST.LAPAP.MOD.DIRECCIONES, Y.ENTY.ID, R.ST.LAPAP.MOD.DIRECCIONES,F.ST.LAPAP.MOD.DIRECCIONES, Y.ERR)

        Y.FECHA.CAMBIO  =  R.ST.LAPAP.MOD.DIRECCIONES<ST.MDIR.DATE.TIME>
        Y.FECHA.LEIBLE = OCONV(ICONV(Y.FECHA.CAMBIO[1,6],"D2/"),'D4Y'):Y.FECHA.CAMBIO[3,4]
        O.DATA = Y.FECHA.LEIBLE
        RETURN

    REPEAT

    O.DATA = ""


RETURN

END
