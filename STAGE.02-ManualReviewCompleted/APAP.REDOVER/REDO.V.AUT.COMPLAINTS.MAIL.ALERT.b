* @ValidationCode : MjotMzc0OTEyMzcxOkNwMTI1MjoxNjgwNzc3OTYwOTAyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:16:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.COMPLAINTS.MAIL.ALERT
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Authorisation routine iw written to send a mail to CUSTOMER once the
* notification is resolved and the routine is attached to REDO.ISSUE.COMPLAINTS,NEW
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : B RENUGADEVI
* PROGRAM NAME : REDO.V.AUT.COMPLAINTS.MAIL.ALERT
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE                          DESCRIPTION
* 20-AUG-2010     BRENUGADEVI        ODR-2009-12-0283                  INITIAL CREATION
* 15-MAY-2011     PRADEEP S          PACS00060849                     Before generating report, R.NEW saved in temp var
*06-04-2023       Conversion Tool    R22 Auto Code conversion          No Changes
*06-04-2023       Samaran T           R22 Manual Code Conversion       No Changes
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_RC.COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY.REPORT
    $INSERT I_F.REPORT.CONTROL
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    $INSERT I_F.REDO.ISSUE.EMAIL
    GOSUB INIT
    GOSUB PROCESS
RETURN

*****
INIT:
*****
    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS  = ''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)

    FN.REDO.ISSUE.EMAIL  = 'F.REDO.ISSUE.EMAIL'
    F.REDO.ISSUE.EMAIL   = ''
    CALL OPF(FN.REDO.ISSUE.EMAIL,F.REDO.ISSUE.EMAIL)

    FN.ENQUIRY.REPORT   = 'F.ENQUIRY.REPORT'
    F.ENQUIRY.REPORT    = ''
    CALL OPF(FN.ENQUIRY.REPORT,F.ENQUIRY.REPORT)

RETURN

********
PROCESS:
********

    Y.ID                = ID.NEW
    Y.LAST.HOLD.ID      = C$LAST.HOLD.ID
    Y.CUS.MAIL.ID       = R.NEW(ISS.COMP.EMAIL)
    Y.NOTIFICATION      = R.NEW(ISS.COMP.CLOSE.NOTIFICATION)
    MSG.EXTRACT.FOLDER  = "&HOLD&"
*
    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    Y.UNIQUE.ID         = UNIQUE.TIME
    FILENAME            = 'APAP-NOTIFICATION':Y.LAST.HOLD.ID:Y.UNIQUE.ID:'.TXT'
    FN.HRMS.FILE        = "B186_Mail_Folder"
    F.HRMA.FILE         = ""
    CALL OPF(FN.HRMS.FILE,F.HRMA.FILE)

    DIM R.NEW.BACK(500)


    IF Y.NOTIFICATION EQ 'YES' THEN
*

        MAT R.NEW.BACK = MAT R.NEW
        ID.NEW.BACK = ID.NEW      ;* PACS00060849 -S/E


        ID.NEW = "REDO.ENQ.COMP.MAIL.ALERT"
        REP.NAME = "REDO.ENQ.COMP.MAIL.ALERT"

*    MATREAD R.NEW FROM F.ENQUIRY.REPORT, REP.NAME THEN ;*Tus Start
        ARRAY.SIZE = ''
        CALL F.MATREAD(FN.ENQUIRY.REPORT,REP.NAME,MAT R.NEW,ARRAY.SIZE,F.ENQUIRY.REPORT,R.NEW.ERR)
        IF NOT(R.NEW.ERR) THEN  ;* Tus End
            CALL ENQUIRY.REPORT.RUN
        END

        MAT R.NEW = MAT R.NEW.BACK
        ID.NEW = ID.NEW.BACK      ;* PACS00060849 -S/E
*
        OPEN MSG.EXTRACT.FOLDER TO FILE.PTR THEN

        END
        READ R.FILE.REC FROM FILE.PTR,Y.LAST.HOLD.ID THEN

        END
*
        CALL CACHE.READ(FN.REDO.ISSUE.EMAIL,'SYSTEM',R.REDO.ISSUE.EMAIL,MAIL.ERR)
        BK.MAIL.ID    = R.REDO.ISSUE.EMAIL<ISS.ML.MAIL.ID>
        Y.FROM.MAIL   = BK.MAIL.ID
        Y.TO.MAIL     = Y.CUS.MAIL.ID
        Y.SUBJECT     = Y.ID:'-':"Notification Solved"
        Y.BODY        = R.FILE.REC
*
        RECORD = Y.FROM.MAIL:"#":Y.TO.MAIL:"#":Y.SUBJECT:"#":Y.BODY
        WRITE RECORD TO F.HRMA.FILE,FILENAME

*
    END
RETURN
END
