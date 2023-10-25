* @ValidationCode : MjoxNzQ3OTA1NTE1OkNwMTI1MjoxNjk4MjM3MjM5MjU3OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:03:59
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
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-33</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ITSS.MF.GENERIC.IBS(REQUEST.PARAM, RESPONSE.PARAM)
*---------------------------------------------------------------------------------------------------
* Description: This is a generic routine used for mobile app to call corresponding routine.
*              For Ex: ITSS.MF.GENERIC,,ITSS.MOBUSER/123456,ARG1=
*              ATTRIBUTES=INTERFACE, SAME.AUTHORISER=YES, CHANNEL=INTERNET
*
*---------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                SM TO @SM,FM TO @FM,VM TO @VM, CALL RTN MODIFIED
*-----------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.EB.MOB.FRMWRK
    $INSERT I_EB.MOB.FRMWRK.COMMON
    $INSERT I_F.EB.EXTERNAL.USER
*---------------------------------------------------------------------------------------------------

    GOSUB INITIALISE

    IF NOT(ERR.RESPONSE) AND Y.METHODE2 NE 'Y' THEN
        GOSUB PROCESS
    END

    GOSUB PROCESS.RESPONSE

    RETURN

*---------------------------------------------------------------------------------------------------
INITIALISE:
*---------
    Y.METHODE2 = 'N'
    ACTION.ID = '' ; EXT.USER.ID = '' ; TOKEN.ID = '' ; CUSTOMER.ID = ''
    ERR.RESPONSE = ''
    R.EB.EXTERNAL.USER = '' ; E.EXT.USER = ''
    ACTION.REC = '' ; MOB.ROUTINE = ''
    RESPONSE = ''

    FILTER.RTN = '' ; INPUT.FORMATTER = '' ; OUTPUT.FORMATTER = ''

*    ARG1 = '' ; ARG2 = '' ; ARG3 = '' ; ARG4 = ''

    SAVE.REQUEST.PARAM = REQUEST.PARAM

    FN.MOB.FRMWRK = 'F.EB.MOB.FRMWRK'
    F.MOB.FRMWRK = ''
    CALL OPF(FN.MOB.FRMWRK, F.MOB.FRMWRK)

    FN.EB.EXTERNAL.USER = 'F.EB.EXTERNAL.USER'
    F.EB.EXTERNAL.USER = ''
    CALL OPF(FN.EB.EXTERNAL.USER, F.EB.EXTERNAL.USER)

    GOSUB PROCESS.REQUEST.PARAM

    IF EXT.USER.ID THEN
     *   CALL F.READ(FN.EB.EXTERNAL.USER, EXT.USER.ID, R.EB.EXTERNAL.USER, F.EB.EXTERNAL.USER, E.EXT.USER)
     *   IF E.EXT.USER THEN
*   ERR.RESPONSE = 'INVALID USER ID - ':EXT.USER.ID
            R.EB.EXTERNAL.USER<EB.XU.CUSTOMER> = CUSTOMER.ID
            EXT.USER.ID = EXT.USER.ID
      *  END
    END
*CALL ITSS.MF.SET.EXTVARIABLES(EXT.USER.ID)
    APAP.IBS.itssMfSetExtvariables(EXT.USER.ID) ;*MANUAL R23 CODE CONVERSION-Call rtn modified.

    GOSUB PROCESS.REQUEST.PARAM

    CALL F.READ(FN.MOB.FRMWRK, ACTION.ID, ACTION.REC, F.MOB.FRMWRK, E.MOB.FRMWRK)

    IF E.MOB.FRMWRK THEN
*        ERR.RESPONSE = 'INVALID ACTION.ID - ':ACTION.ID
        MOB.OFS.REQUEST = REQUEST
        MOB.RESPONSE = ""
        MOB.ERROR=""

        GOSUB EXEC.REQUEST
        RESPONSE = MOB.RESPONSE
        ERR.RESPONSE = MOB.ERROR

        Y.METHODE2 = 'Y'
        RETURN
    END

*    CALL System.loadVariables
*    CALL EB.EXTERNAL.USER.SWITCH('', EXT.USER.ID)


    RETURN

*---------------------------------------------------------------------------------------------------
PROCESS.REQUEST.PARAM:
*---------------------
* Set the USER.ID, ACTION.ID & TOKEN.ID based on the message

*    GEN.INFO.CNT = COUNT(REQUEST.PARAM, '=')

*    FOR I=1 TO GEN.INFO.CNT
    FOR I=1 TO 4
        GEN.VAL = REQUEST.PARAM[',', I, 1]
        BEGIN CASE
        CASE GEN.VAL['=', 1, 1] EQ 'ACTION.ID'
            ACTION.ID = GEN.VAL['=', 2, 1]
        CASE GEN.VAL['=', 1, 1] EQ 'USER.ID'
            EXT.USER.ID = GEN.VAL['=', 2, 1]
        CASE GEN.VAL['=', 1, 1] EQ 'TOKEN.ID'
            TOKEN.ID = GEN.VAL['=', 2, 1]
        CASE GEN.VAL['=', 1, 1] EQ 'CUSTOMER.ID'
            CUSTOMER.ID = GEN.VAL['=', 2, 1]

        END CASE

    NEXT I

*    REST.PARAM = REQUEST.PARAM[',', GEN.INFO.CNT+1, 9999]
    REST.PARAM = REQUEST.PARAM[',', 5, 9999]
    REQUEST = REST.PARAM

    RETURN

*---------------------------------------------------------------------------------------------------
PROCESS:
*-------
* Read the EB.MOB.FRMWRK file based on the ACION.ID and call the corresponding routine.

    FILTER.RTN = ACTION.REC<EB.MF.FILTER.RTN>

    IF FILTER.RTN THEN
        ID.LIST = REQUEST
        CALL @FILTER.RTN(ID.LIST)
        REQUEST = ID.LIST
    END

    INPUT.FORMATTER = ACTION.REC<EB.MF.INPUT.FORMATTER>

    IF INPUT.FORMATTER THEN
        CALL @INPUT.FORMATTER(REQUEST)
    END

    MOB.ROUTINE = ACTION.REC<EB.MF.ROUTINE>

    ACTION.INFO = ACTION.ID:',':EXT.USER.ID:',':TOKEN.ID

*    GOSUB PARSE.ARGUMENTS

*    CALL @MOB.ROUTINE(ACTION.INFO, ARG1, ARG2, ARG3, ARG4, RESPONSE, ERR.RESPONSE)
    CALL @MOB.ROUTINE(ACTION.INFO, REQUEST, RESPONSE, ERR.RESPONSE)


    OUTPUT.FORMATTER = ACTION.REC<EB.MF.OUTPUT.FORMATTER>

    IF OUTPUT.FORMATTER THEN
        CALL @OUTPUT.FORMATTER(REQUEST,RESPONSE)
    END

*    RESPONSE.PARAM = RESPONSE


    RETURN

*---------------------------------------------------------------------------------------------------
PARSE.ARGUMENTS:
*---------------

    ARG1 = REST.PARAM
*    ARG1 = REST.PARAM[',',1,1]
*    ARG2 = REST.PARAM[',',2,1]
*    ARG3 = REST.PARAM[',',3,1]
*    ARG4 = REST.PARAM[',',4,1]

*    CHANGE ';' TO FM IN ARG1
*    CHANGE ';' TO FM IN ARG2
*    CHANGE ';' TO FM IN ARG3
*    CHANGE ';' TO FM IN ARG4

    RETURN

*---------------------------------------------------------------------------------------------------
PROCESS.RESPONSE:
*----------------

    RESPONSE.PARAM<1> = EXT.USER.ID
    RESPONSE.PARAM<2> = ACTION.ID
    RESPONSE.PARAM<3> = TOKEN.ID
    RESPONSE.PARAM<4> = ERR.RESPONSE
    RESPONSE.PARAM<5> = RESPONSE


    RETURN

*---------------------------------------------------------------------------------------------------
EXEC.REQUEST:
    THE.REQUEST = MOB.OFS.REQUEST
    THE.RESPONSE = ''
    REQUEST.COM = ''
*    PRINT THE.REQUEST
    CALL OFS.BULK.MANAGER(THE.REQUEST, THE.RESPONSE, REQUEST.COM)
*    PRINT THE.RESPONSE
    IF THE.REQUEST[1,14] NE 'ENQUIRY.SELECT' AND ACTION.ID NE "ENQUIRY"  THEN
        REQUEST.CHECK = REQUEST.COM
        IF THE.REQUEST[',',2,1]['/',3,1] EQ 'VALIDATE' THEN
            REQUEST.CHECK = 1
        END
        IF THE.RESPONSE[',',1,1]['/',3,1] EQ '1' THEN
            RESPONSE.CHECK =1
        END
        IF RESPONSE.CHECK OR ACTION.ID EQ "ROUTINE" THEN
            MOB.RESPONSE = THE.RESPONSE
        END ELSE
            MOB.ERROR = THE.RESPONSE
        END
        IF MOB.RESPONSE THEN
            APPL.HEADER = '@ID':@FM:'MESSAGE.ID':@FM:'SUCCESS'
            CONVERT ',' TO @FM IN MOB.RESPONSE
            HEADER.RESPONSE = FIELDS(MOB.RESPONSE, '=', 1)
            HEADER.RESPONSE<1> = APPL.HEADER
            VALUE.RESPONSE = FIELDS(MOB.RESPONSE, '=', 2)
            VALUE.ID.RESPONSE = MOB.RESPONSE<1>
            CONVERT '/' TO @FM IN VALUE.ID.RESPONSE
            VALUE.RESPONSE<1> = VALUE.ID.RESPONSE
            HEADER.RESPONSE = LOWER(LOWER(HEADER.RESPONSE))
            VALUE.RESPONSE = LOWER(LOWER(VALUE.RESPONSE))
            CONVERT ':' TO '-' IN HEADER.RESPONSE
            MOB.RESPONSE = HEADER.RESPONSE:@VM:VALUE.RESPONSE
        END
    END ELSE
*        PRINT ACTION.ID

        MOB.RESPONSE = THE.RESPONSE[3,LEN(THE.RESPONSE)-2]

        CONVERT '"' TO "'" IN MOB.RESPONSE
        Y.DELIMITER = '#'
        Y.CLEAN.DATA=""
        MOB.ERROR =""

        Y.NB.ECH.CALC = DCOUNT(MOB.RESPONSE,Y.DELIMITER)

        IF THE.RESPONSE EQ "NONE'" THEN
            MOB.ERROR = "NO DATA FOUND"
        END

        IF FIELDS(MOB.RESPONSE,Y.DELIMITER,1) EQ "'No records were found that matched the selection criteria'" THEN
            MOB.ERROR = "NO DATA FOUND"
        END
        IF NOT(MOB.ERROR) THEN
            Y.HEADER = FIELD(MOB.RESPONSE,Y.DELIMITER,1)
            CONVERT ";" TO @SM IN Y.HEADER
            Y.CLEAN.DATA<1,-1> = Y.HEADER
            FOR I = 2 TO Y.NB.ECH.CALC
                Y.CLEAN.DATA<1,-1> = FIELD(MOB.RESPONSE,Y.DELIMITER,I)
            NEXT I
            Y.NB = Y.NB.ECH.CALC
            Y.DELIMIT2 = ";"
            Y.NUM.ECH = "1"
            FOR I = 2 TO Y.NB
                Y.RECORD = ""
                Y.NB.FIELD = DCOUNT(Y.CLEAN.DATA<1,I>,Y.DELIMIT2)
                FOR J=1 TO Y.NB.FIELD
                    Y.PTR = FIELDS(Y.CLEAN.DATA<1,I>,Y.DELIMIT2,J)
                    CONVERT '"' TO "" IN Y.PTR
                    Y.RECORD<1,1,-1> = Y.PTR
                NEXT J
                Y.CLEAN.DATA<1,I> = Y.RECORD
            NEXT I
            MOB.RESPONSE = Y.CLEAN.DATA
        END
    END
    RETURN


END
