* @ValidationCode : Mjo1NDg2MTk3ODQ6Q3AxMjUyOjE2ODE5OTU5ODc4NjI6SVRTUzotMTotMToxNjU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Apr 2023 18:36:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 165
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.SC.TRADING.LIMIT(Y.OUT.ARRAY)
*-----------------------------------------------------------------------------
*COMPANY NAME: Group Financiero Banorte
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: NOFILE routine
*------------
*DESCRIPTION:
*------------
*  This routine is attached as NOFILE routine for the ENQUIRY REDO.APAP.SC.TRADING.LIMIT
* The routine makes the select over the records of REDO.APAP.USER.LIMITS based on user selection
* process the same
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : Y.OUT.ARRAY
*
*---------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 08-NOV-2010   A.SabariKumar     ODR-2010-07-0075       Initial Creation

* 13-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 13-APR-2023      Harishvikram C    Manual R22 conversion      No changes
*---------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.APAP.USER.LIMITS

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------
INITIALISE:
*------------
*Initialise/Open necessary varibles/files

    Y.EXP.DAYS = ''
    EXP.POS = ''
    Y.TODAY = ''
    SEL.CMD = ''
    SEL.LIST = ''
    USR.POS = ''
    SEL.ERR = ''
    Y.USR.ID = ''
    R.USR.LIM = ''
    USR.ERR = ''
    Y.DIFF = 'C'

    FN.REDO.APAP.USER.LIMITS = 'F.REDO.APAP.USER.LIMITS'
    F.REDO.APAP.USER.LIMITS =  ''
    CALL OPF(FN.REDO.APAP.USER.LIMITS,F.REDO.APAP.USER.LIMITS)

RETURN

*---------------------------------------------------------------------------
PROCESS:
*-----------
* The section forms the outgoing array based on the user selection equaling the
* fetched field accordingly

    Y.TODAY = TODAY
    LOCATE "EXPIRY.DAYS" IN D.FIELDS<1> SETTING EXP.POS THEN
        Y.EXP.DAYS =  D.RANGE.AND.VALUE<EXP.POS>
        SEL.CMD = 'SELECT ':FN.REDO.APAP.USER.LIMITS
    END
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    Y.USR.ID = ''
    LOOP
        REMOVE Y.USR.ID FROM SEL.LIST SETTING USR.POS
    WHILE Y.USR.ID:USR.POS
        Y.LIM.DATE = ''
        GOSUB FETCH.VALID.DATE
        Y.DIFF = 'C'
        IF Y.TODAY NE '' AND Y.LIM.DATE NE '' THEN
            CALL CDD('',Y.TODAY,Y.LIM.DATE,Y.DIFF)
        END
        IF Y.EXP.DAYS EQ Y.DIFF THEN
            GOSUB FORM.ARRAY
        END
    REPEAT
RETURN

*---------------------------------------------------------------------------
FETCH.VALID.DATE:
*----------------
* Reads the local template "REDO.APAP.USER.LIMITS" and fetchs the required values
* (i.e.)SC.LIMIT.DATE

    CALL F.READ(FN.REDO.APAP.USER.LIMITS,Y.USR.ID,R.USR.LIM,F.REDO.APAP.USER.LIMITS,USR.ERR)
    Y.LIM.DATE = R.USR.LIM<REDO.USR.LIM.SC.LIMIT.DATE>
RETURN

*---------------------------------------------------------------------------
FORM.ARRAY:
*-----------
* The section forms the oputgoing array for the enquiry output

    Y.OUT.ARRAY<-1> = Y.USR.ID:"*":Y.LIM.DATE

RETURN
*---------------------------------------------------------------------------
END
