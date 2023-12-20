* @ValidationCode : MjotMTIzNjM5NDgxMDpDcDEyNTI6MTY5ODQwNTUzOTM1NzpJVFNTMTotMTotMTowOjE6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:48:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>330</Rating>
*-----------------------------------------------------------------------------
*    SUBROUTINE ITSS.MF.GET.APPL.FIELDS(ACTION.INFO, APPL.IDS, RESERVED.2, RESERVED.3, RESERVED.4, MOB.RESPONSE, MOB.ERROR)
    SUBROUTINE ITSS.MF.GET.APPL.FIELDS(ACTION.INFO, APPL.IDS, MOB.RESPONSE, MOB.ERROR)
*---------------------------------------------------------------------------------------------------
* Description : This is a generic routine to extract the application fields as defined for
*               the application and fields as defined in EB.MOB.FRMWRK
*---------------------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                VM TO @VM,SM TO @SM,FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.MOB.FRMWRK
    $INSERT I_EB.MOB.FRMWRK.COMMON
    $INSERT I_F.STANDARD.SELECTION
*---------------------------------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB EXTRACT.DATA

    MOB.RESPONSE = EXT.APPLS.VALUES

    RETURN

*---------------------------------------------------------------------------------------------------
INITIALISE:
*----------

    EXT.APPLS = ACTION.REC<EB.MF.APPL>
    EXT.APPLS.FIELDS = ACTION.REC<EB.MF.APPL.FIELDS>
    EXT.APPLS.COL.NAMES = ACTION.REC<EB.MF.APPL.COL.NAMES>

    EXT.APPL.CNT = DCOUNT(EXT.APPLS, @VM)
    EXT.APPLS.VALUES = ''

*    CHANGE ';' TO FM IN APPL.IDS

    LNGG = 2

    RETURN


PARSE.MF.APPLICATION:
*--------------------

    EXT.APPL = EXT.APPLS<1, APP.CNT>
    EXT.APPL.FIELDS = EXT.APPLS.FIELDS<1, APP.CNT>
    EXT.APPL.COL.NAMES = EXT.APPLS.COL.NAMES<1, APP.CNT>

    EXT.TOT.FLD = DCOUNT(EXT.APPL.FIELDS, @SM)

    EXT.APPL.HEADER = EXT.APPL.COL.NAMES

    FN.EXT.APPL = 'F.':EXT.APPL
    F.EXT.APPL = ''
    CALL OPF(FN.EXT.APPL, F.EXT.APPL)

    SS.FILE = "F.STANDARD.SELECTION"
    E.SS.FILE = ""
    CALL CACHE.READ(SS.FILE, EXT.APPL, EXT.APPL.SS, E.SS.FILE)

    IF E.SS.FILE NE "" THEN
*        E = 'MISSING STANDARD.SELECTION RECORD FOR ':EXT.APPL:' IN EB.MOB.FRMWRK - ACTION.ID = ':ACTION.ID
*        GOSUB FATAL.ERROR
*       ETEXT = 'EB-MISS.STANDARD.SELECTION.REC'
*       CALL STORE.END.ERROR
        MOB.ERROR = 'MISSING STANDARD.SELECTION RECORD FOR ':EXT.APPL:' IN EB.MOB.FRMWRK - ACTION.ID = ':ACTION.ID
    END

    RETURN

*---------------------------------------------------------------------------------------------------
EXTRACT.DATA:
*------------

    APPL.IDS.CNT = DCOUNT(APPL.IDS, @FM)

    IF NOT(APPL.IDS) THEN MOB.ERROR = 'No Record Ids for Extraction'
*    EXT.APPL.VALUES<1, 1> = EXT.APPL.HEADER

    FOR APP.CNT = 1 TO EXT.APPL.CNT
        GOSUB PARSE.MF.APPLICATION
        IF MOB.ERROR THEN
            RETURN
        END
        EXT.APPLS.VALUES<APP.CNT, 1> = EXT.APPL.HEADER
        FOR ID.CNT = 1 TO APPL.IDS.CNT

            E.EXT.APPL = ''
            APPL.ID = APPL.IDS<ID.CNT>

* CALL F.READ(FN.EXT.APPL, APPL.ID, APPL.REC, F.EXT.APPL, E.EXT.APPL)

            READ APPL.REC FROM F.EXT.APPL,APPL.ID ELSE E.EXT.APPL = 'RECORD NO FOUND'

            IF E.EXT.APPL THEN
                MOB.ERROR = 'RECORD MISSING - ':APPL.ID:' IN ':EXT.APPL
                RETURN
            END

            FOR FLD.CNT=1 TO EXT.TOT.FLD
                EXT.FLD.NAME = EXT.APPL.FIELDS<1, 1, FLD.CNT>
                IF INDEX(EXT.FLD.NAME, '>', 1) THEN
                    GOSUB RESET.CURR.VARS
                    CURR.FLD.NO = EXT.FLD.NAME
                    GOSUB GET.J.TYPE
                END ELSE
                    GOSUB CHECK.FIELD.TYPE
                END
                EXT.APPLS.VALUES<APP.CNT, ID.CNT+1, FLD.CNT> = CURR.FLD.VAL

                IF MOB.ERROR THEN
                    RETURN
                END

            NEXT FLD.CNT

        NEXT ID.CNT

    NEXT APP.CNT

    RETURN


*---------------------------------------------------------------------------------------------------
CHECK.FIELD.TYPE:
*----------------

    GOSUB RESET.CURR.VARS

    LOCATE EXT.FLD.NAME IN EXT.APPL.SS<SSL.SYS.FIELD.NAME, 1> SETTING CURR.FLD.POS THEN
        CURR.FLD.TYPE = EXT.APPL.SS<SSL.SYS.TYPE, CURR.FLD.POS>
        CURR.FLD.NO = EXT.APPL.SS<SSL.SYS.FIELD.NO, CURR.FLD.POS>
        CURR.FLD.VAL.TYPE = EXT.APPL.SS<SSL.SYS.SINGLE.MULT, CURR.FLD.POS>
        CURR.FLD.LANG.TYPE = EXT.APPL.SS<SSL.SYS.LANG.FIELD, CURR.FLD.POS>
    END ELSE
        LOCATE EXT.FLD.NAME IN EXT.APPL.SS<SSL.USR.FIELD.NAME, 1> SETTING CURR.FLD.POS THEN
            CURR.FLD.TYPE = EXT.APPL.SS<SSL.USR.TYPE, CURR.FLD.POS>
            CURR.FLD.NO = EXT.APPL.SS<SSL.USR.FIELD.NO, CURR.FLD.POS>
            CURR.FLD.VAL.TYPE = EXT.APPL.SS<SSL.USR.SINGLE.MULT, CURR.FLD.POS>
            CURR.FLD.LANG.TYPE = EXT.APPL.SS<SSL.USR.LANG.FIELD, CURR.FLD.POS>
        END ELSE
*            E = 'INVALID FIELD ':EXT.FLD.NAME:' FOR ':EXT.APPL:' IN MOB.FRMWRK - ACTION.ID = ':ACTION.ID
*            GOSUB FATAL.ERROR
            MOB.ERROR = 'INVALID FIELD ':EXT.FLD.NAME:' FOR ':EXT.APPL:' IN MOB.FRMWRK - ACTION.ID = ':ACTION.ID
            RETURN
        END
    END

    IF CURR.FLD.LANG.TYPE EQ "Y" THEN CURR.FLD.LANG.POS = LNGG

    BEGIN CASE
    CASE CURR.FLD.TYPE EQ "D"
        GOSUB GET.D.TYPE
    CASE CURR.FLD.TYPE EQ "J"
        GOSUB GET.J.TYPE
    CASE CURR.FLD.TYPE EQ "I"
        GOSUB GET.I.TYPE
    END CASE

    RETURN

*---------------------------------------------------------------------------------------------------
RESET.CURR.VARS:
*---------------
    CURR.FLD.POS = ''
    CURR.FLD.TYPE = ''
    CURR.FLD.NO = ''
    CURR.FLD.VAL.TYPE = ''
    CURR.FLD.LANG.TYPE = ''
    CURR.FLD.LANG.POS = ''

    RETURN

*---------------------------------------------------------------------------------------------------
GET.D.TYPE:
*----------

    BEGIN CASE
    CASE CURR.FLD.NO EQ 0
        CURR.FLD.VAL = APPL.ID
    CASE CURR.FLD.LANG.POS
        CURR.FLD.VAL = APPL.REC<CURR.FLD.NO, CURR.FLD.LANG.POS>
        IF CURR.FLD.VAL EQ "" THEN
            CURR.FLD.VAL = APPL.REC<CURR.FLD.NO,1>
        END
    CASE CURR.FLD.VAL.TYPE EQ 'M'
        CURR.FLD.VAL = APPL.REC<CURR.FLD.NO>
        GOSUB CONV.MULTI.SEP  ;* Convert system delimiter to generic separator
    CASE OTHERWISE
        CURR.FLD.VAL = APPL.REC<CURR.FLD.NO>
    END CASE


    RETURN

*---------------------------------------------------------------------------------------------------
GET.J.TYPE:
*----------

    SAVE.CURR.FLD.POS = CURR.FLD.POS
    SAVE.CURR.FLD.TYPE = CURR.FLD.TYPE
    SAVE.CURR.FLD.NO = CURR.FLD.NO
    SAVE.CURR.FLD.VAL.TYPE = CURR.FLD.VAL.TYPE
    SAVE.CURR.FLD.LANG.TYPE = CURR.FLD.LANG.TYPE
    SAVE.CURR.FLD.LANG.POS = CURR.FLD.LANG.POS

    EXT.FLD.NAME = SAVE.CURR.FLD.NO['>', 1, 1]
    GOSUB CHECK.FIELD.TYPE
    JCURR.FLD.VAL = CURR.FLD.VAL

    JLINK.CNT = DCOUNT(SAVE.CURR.FLD.NO, '>')
    REM.JLINK =  SAVE.CURR.FLD.NO['>', 2, JLINK.CNT]

    CALL EB.GET.JDESCRIPTOR.VALUES(JCURR.FLD.VAL, REM.JLINK)

*    CURR.FLD.VAL = JCURR.FLD.VAL

    ACT.J.APPL = SAVE.CURR.FLD.NO['>', JLINK.CNT-1, 1]
    ACT.J.FLD = SAVE.CURR.FLD.NO['>', JLINK.CNT, 1]

    CALL CACHE.READ(SS.FILE, ACT.J.APPL, ACT.J.APPL.SS, E.ACT.J.APPL.SS)

    IF E.ACT.J.APPL.SS NE "" THEN
*        E = 'MISSING STANDARD.SELECTION RECORD FOR ':ACT.J.APPL:' IN EB.MOB.FRMWRK - ACTION.ID = ':ACTION.ID
*        GOSUB FATAL.ERROR
*       ETEXT = 'EB-MISS.STANDARD.SELECTION.REC'
*       CALL STORE.END.ERROR
        MOB.ERROR = 'MISSING STANDARD.SELECTION RECORD FOR ':ACT.J.APPL:' IN EB.MOB.FRMWRK - ACTION.ID = ':ACTION.ID
        RETURN
    END

    LOCATE ACT.J.FLD IN ACT.J.APPL.SS<SSL.SYS.FIELD.NAME, 1> SETTING J.APPL.FLD.POS THEN
        ACT.J.FLD.LANG.TYPE = ACT.J.APPL.SS<SSL.SYS.LANG.FIELD, J.APPL.FLD.POS>
        ACT.J.FLD.VAL.TYPE = ACT.J.APPL.SS<SSL.SYS.SINGLE.MULT , J.APPL.FLD.POS>
    END ELSE
        LOCATE ACT.J.FLD IN ACT.J.APPL.SS<SSL.USR.FIELD.NAME, 1> SETTING J.APPL.FLD.POS THEN
            ACT.J.FLD.LANG.TYPE = ACT.J.APPL.SS<SSL.USR.LANG.FIELD, J.APPL.FLD.POS>
            ACT.J.FLD.VAL.TYPE = ACT.J.APPL.SS<SSL.USR.SINGLE.MULT , J.APPL.FLD.POS>
        END ELSE
*            E = 'INVALID FIELD ':ACT.J.FLD:' FOR ':ACT.J.APPL:' IN MOB.FRMWRK - ACTION.ID = ':ACTION.ID
*            GOSUB FATAL.ERROR
            MOB.ERROR = 'INVALID FIELD ':ACT.J.FLD:' FOR ':ACT.J.APPL:' IN MOB.FRMWRK - ACTION.ID = ':ACTION.ID
            RETURN
        END
    END

    BEGIN CASE
    CASE ACT.J.FLD.LANG.TYPE EQ 'Y'
        CURR.FLD.VAL = JCURR.FLD.VAL<1, LNGG>
        IF CURR.FLD.VAL EQ "" THEN
            CURR.FLD.VAL = JCURR.FLD.VAL<1, 1>
        END
    CASE ACT.J.FLD.VAL.TYPE EQ 'M'
        CURR.FLD.VAL = JCURR.FLD.VAL
        GOSUB CONV.MULTI.SEP
    CASE OTHERWISE
        CURR.FLD.VAL = JCURR.FLD.VAL
    END CASE

*    IF ACT.J.FLD.LANG.TYPE EQ "Y" THEN CURR.FLD.VAL = CURR.FLD.VAL<1, LNGG>

    RETURN

*---------------------------------------------------------------------------------------------------
GET.I.TYPE:
*----------

    I.FN.EXT.APPL = ''
    I.APPL.ID = APPL.ID
    I.APPL.REC = APPL.REC
    I.FLD.NAME = EXT.FLD.NAME
    I.FLD.VAL = ''
    CALL IDESC(FN.EXT.APPL, I.APPL.ID, I.APPL.REC, I.FLD.NAME, IFLD.VAL)

    BEGIN CASE
    CASE CURR.FLD.LANG.POS
        CURR.FLD.VAL = IFLD.VAL<1, CURR.FLD.LANG.POS>
        IF CURR.FLD.VAL EQ "" THEN
            CURR.FLD.VAL = IFLD.VAL<1, 1>
        END
    CASE CURR.FLD.VAL.TYPE EQ 'M'
        CURR.FLD.VAL = IFLD.VAL
        GOSUB CONV.MULTI.SEP
    CASE OTHERWISE
        CURR.FLD.VAL = IFLD.VAL
    END CASE

    RETURN

*---------------------------------------------------------------------------------------------------
CONV.MULTI.SEP:
*--------------

    CHANGE @VM TO ':' IN CURR.FLD.VAL
    CHANGE @SM TO ':' IN CURR.FLD.VAL

*    CHANGE VM TO SM IN CURR.FLD.VAL


    RETURN
*---------------------------------------------------------------------------------------------------
FATAL.ERROR:
*-----------
    FATAL.INFO<1> = 'ITSS.MF.GET.APPL.FIELDS'
    FATAL.INFO<6> = E

    CALL FATAL.ERROR(FATAL.INFO)

    RETURN

*---------------------------------------------------------------------------------------------------
END
