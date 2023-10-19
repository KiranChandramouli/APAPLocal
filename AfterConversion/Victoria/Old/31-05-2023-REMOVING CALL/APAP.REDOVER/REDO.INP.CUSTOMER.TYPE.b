* @ValidationCode : MjoxNDI2NDUzMjk4OkNwMTI1MjoxNjgyNDEyMzMxMDgwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.CUSTOMER.TYPE
*--------------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION :
* Note    : Passport number number validation will not be done against Padrones interface, user manually checks for non apap customers
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Ganesh R
* PROGRAM NAME : REDO.INP.CUSTOMER.TYPE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 07-July-2011      Riyas               CR014          Initial creation
* 11-10-2011      Shankar Raju       PACS00142987  Removing C$SPARE & Making CUSTOMER.NAME field as inputable field if
*                                                  Client is Non-APAP & using Passport.
*-----------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          FM TO @FM
*06-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
*
    $INSERT I_F.REDO.ID.CARD.CHECK
*
    GOSUB INIT
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
*---------------------------------------------------------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------------------------------------------------
*
    PASSPORT.CUST.ID   = "NA"
    CUSTOMER.FULL.NAME = R.NEW(REDO.CUS.PRF.CUSTOMER.NAME)
    PASSPORT.NUMBER    = R.NEW(REDO.CUS.PRF.IDENTITY.NUMBER)
    VAR.CUS.DETAILS    = "PASAPORTE*":PASSPORT.NUMBER:"*":CUSTOMER.FULL.NAME:"*":PASSPORT.CUST.ID
    CALL System.setVariable("CURRENT.VAR.DETAILS",VAR.CUS.DETAILS)
*
RETURN
*
* ================
CONTROL.MSG.ERROR:
* ================
*
*   Paragraph that control the error in the subroutine
*
    IF Y.ERR.MSG THEN
        AF    = REDO.CUS.PRF.CUSTOMER.TYPE
        ETEXT = Y.ERR.MSG
        CALL STORE.END.ERROR
    END
*
RETURN
*
* =================
GET.USER.VARIABLES:
* =================
*
    WVAR.NAME = "CURRENT.CLIENTE.APAP"
    WVAR.VAL  = ""
    WPOS.X    = 0
*
    CALL System.getUserVariables( U.VARNAMES, U.VARVALS )
*
    LOOP
        REMOVE WWVAR FROM WVAR.NAME SETTING WVAR.POS
    WHILE WWVAR : WVAR.POS DO
        WPOS.X += 1
        LOCATE WWVAR IN U.VARNAMES SETTING YPOS.VAR THEN
            WVAR.VAL<WPOS.X> = U.VARVALS<YPOS.VAR>
        END
    REPEAT
*
RETURN
*
* ===
INIT:
* ===
*
    PROCESS.GOAHEAD    = 1
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE) NE "NO CLIENTE APAP" OR R.NEW(REDO.CUS.PRF.IDENTITY.TYPE) NE "PASAPORTE" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2
                GOSUB GET.USER.VARIABLES
                IF WVAR.VAL EQ "" THEN
                    Y.ERR.MSG       = "EB-USER.VARIABLE.&.NOT.DEFINED":@FM:WVAR.NAME
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 3
                Y.CLIENTE.APAP = WVAR.VAL
                Y.CUS.TYPE     = R.NEW(REDO.CUS.PRF.CUSTOMER.TYPE)

                IF Y.CUS.TYPE NE Y.CLIENTE.APAP THEN
                    Y.ERR.MSG       = "EB-CLIENTE.APAP"
                    PROCESS.GOAHEAD = ""
                END

        END CASE
*       Message Error
        GOSUB CONTROL.MSG.ERROR
*       Increase
        LOOP.CNT += 1
*
    REPEAT
*
RETURN

END
