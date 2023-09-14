* @ValidationCode : MjoxODUzODY5NTk6Q3AxMjUyOjE2ODIzMTUyNTU5MzI6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:17:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TEST
* Version 9 15/11/00  GLOBUS Release No. G14.0.01 12/08/03

SUBROUTINE OFS.GLOBUS.MANAGER.2(K.OFS.SOURCE,OFS.MESSAGE)
******************************************************************
* MODIFICATION HISTORY:
*
* 21/09/02 - EN_10001187
*            Conversion of error messages to error codes.
*
* 23/09/02 - CI_10003777
*            OFS.SOURCE does not accept "NULL" as value . This has
*            to be "NONE" instead.
*
* 28/08/03 - GLOBUS_BG_100004988
*            Added check for running from a Browser session.
*            Ensure that the OFS$SOURCE variable are not overwritten before being
*               backed-up.
*
* 16/09/03 - EN_10001999
*            Implementation of OFS in Corporate Action.
*
* 05/11/03 - BG_100005608
*            CLOSESEQ has been done.
*
* 11/02/04 - BG_100006184
*            Save and restore the commons used by browser.
*
* 13/04/04 - GLOBUS_BG_100006476
*            CLOSESEQ the OFS log file before the common variables are restored
*               otherwise the variable will is destroyed.
*            Save and restore INPUT.BUFFER
*
* 21/04/04 - GLOBUS_EN_10002238
*            Provide Integrity check for localdevelopments to ensure
*            that the system is not corrupted.
*            SAR Ref.No.SAR-2003-11-21-0008
*
* 23/06/04 - GLOBUS_BG_100006633
*            Blank OFS$ACTIVE.MSG.REF for calls to OFS.REQUEST.MANAGER
*               otherwise mutiple calls to this routine will fail due to a non-unique
*               message reference.  This will by-pass these checks.
* 05/07/04 - BG_100006897
*            Initialise the log file common variables
*
* 12/07/04 - GLOBUS_EN_10002306
*            To allow messages with any SOURCE.TYPE (not just GLOBUS)
*            to be processed.
*
* 04/10/04 - BG_100007375
*      In OPF, T.OPF just hold the filenames, a new dimensioned array(T.OPF.ADDITIONAL.INFO)
*            in common is introduced to hold the other info - real file name etc.
*            Just like OPF.NO,R.OPF,T.OPF save and restore the above dimensioned array as well.
*
* 19/10/04 - BG_100007486
*            Cache Read OFS.SOURCE.
*
* 16/11/04 - GLOBUS_EN_10002369
*            Back-up and restore new common OFS$WARNINGS.
*
* 10/02/04 - GLOBUS_BG_100008069
*            Back-up and restore new common OFS$PREVIOUS.ENQS.
*
* 29/03/05 - GLOBUS_CI_10027659
*            Don't call APPLICATION in RESTORE.APP para if the PGM.TYPE is 'D' or 'M'.
*
* 01/06/05 - GLOBUS_EN_100002460
*            Allow EB.TABLE.DEFINITION applications to be run through OFS.
*
* 13/09/05 - GLOBUS_EN_10002668
*            Ensure that sensitivity is removed and check that write
*            cache is empty.
*
* 13/09/05 - GLOBUS_EN_10002665
*            Back-up and restore new common OFS$NEW.COMMAND.
*
* 20/09/05 - GLOBUS_GB_100009416
*            Back-up and restore new common OFS$MESSAGE.
*
* 18/11/05 - CI_10036592
*            Check for PGM.TYPE[1,1] to determine whether to run the application
*            or not in the restore section.
*            Ref:HD0515417
*
* 27/01/06 - GLOBUS_BG_100010080
*            Removed the save/restore of OFS$GETTING.ID as we no longer require this variable
*            It has been replaced by OFS$STATUS<STAT.FLAG.GETTING.ID> which has now been added.
*            Also added the common vars required by Teller Passbook Printing to be saved/restored
*
* 18/04/06 - EN_10002888
*            Automatic PW Process creation
*
* 09/08/06 - EN_10003215
*            Allow use of JOURNAL.BYPASS and keep the cache intact
*            This is only allowed for AA
*            Also create a default OFS.SOURCE record if one is not
*            specified
*
* 09/04/07 - BG_100013578
*            Preserve the template variables - new templates are corrupted
*            using OGM
*
* 18/09/07 - CI_10051423
*            Unable to call OFS.GLOBUS.MANAGER in VALIDATE mode from Versions as an
*            Authorization Routine.
*            Ref:HD0715453
*
* 13/02/08 - CI_10053689
*            Error during upgrade when more than 200 companies are created.
*
* 13/02/08 - BG_100016086
*            Changes made to set the OFS message in to a common variable for checking inward
*            delivery messages.
*
* 02/05/08 - CI_10055131
*            Instead of restoring the arrays R.COMPANY and ID.COMPANY alone,
*            better call LOAD.COMPANY.
*            CSS Ref : HD0806161
*
* 04/07/07 - GLOBUS_EN_10003742   SAR-2007-04-21-0004
*            Backup and restore common OFS$PREVIOUS.ENQ.TITLES
*
* 23/12/08 - CI_10059634
*            Customer record gets encrypted twice when updated via fast path
*            enquiry.
*            1)Need to set OFS$BROWSER to null before processing vanilla ofs request.
*            2)Initialise ENC$ENCRYPT.FLAG to null as control doesn't to go from OFS.SESSION.MANAGER
*            REF:HD0835476
*
* 04/02/09 - BG_100021935
*            WRITE.CACHE enabled for jobs using OFS.GLOBUS.MANAGER.So,the cache variables
*            should not be restored back when WRITE.CACHE is set as the records are picked from
*            the cache variables and written into the disk in BATCH.JOB.CONTROL.
*
* 04/09/09 - CI_10065870
*            Backup and restore common OFS$VERSION.FLD
*            CSS Ref : HD0931729
*
* 10/09/09 - CI_10066012
*            Get the backup of the current OFS SOURCE ID(in K.OFS.SOURCE) into the common variable OFS$SOURCE.ID.BACKUP
*
* 26/11/09 - BG_100025926
*            While running the service SWIFT.IN, If batch job name is same as
*            application name then don't call EB.EXECUTE.APPLICATION
*            TTS ref:TTS0908417
*
* 18/06/10 - Defect : 57470 / Task : 59696
*            Fatal error is thrown when OFS.GLOBUS.MANAGER is called in Hook Routines with OFS enquiry request.
*            Fix in BG_100025926 is reverted as the TTS issue arised due to the improper set up.
*
* 01/07/10 - Task - 63961 (Defect : 59955)
*            Introducing the caching mechanism for OGM
*
* 1/11/2011 - EN-185375 / Task-297323 - Logger Enhancement
*            Open,create and closing of OFS log file directory can be done only if T24 level logs enabled, otherwise
*    TAFC logging will be used by default.
*-------------------------------------------------------------------------------------
*Modification
* Date                   who                   Reference              
* 24-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - = TO EQ AND VM TO @VM AND # TO NE AND TNO TO C$T24.SESSION.NO AND CONVERT TO CHANGE AND HUSH ON TO CALL HUSHIT(1) AND HUSH OF TO CALL HUSHIT(0) AND > TO GT AND ADDED END FOR IF
* 24-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------
*
****************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.SPF
    $INSERT I_GTS.COMMON
    $INSERT I_IO.EQUATE
    $INSERT I_F.OFS.STATUS.FLAG         ;* GLOBUS_BG_100010080
    $INSERT I_PW.COMMON       ;* EN_10002888 S/E
    $INSERT I_OFS.MESSAGE.DEL.COMMON    ;* BG_100016086
    $INSERT I_METHODS.AND.PROPERTIES
    $INSERT I_ENCRYPT.COMMON

******************************************************************
*    DEBUG
    GOSUB INITIALISE

* GLOBUS_EN_10002306 /S
    IF ETEXT NE "" THEN
        RETURN
    END ;*R22 AUTO CONVERSTION ADDED END FOR IF
* GLOBUS_EN_10002306 /E

* Is there another version of OFS.GLOBUS.MANAGER active?
* If so add OFS Message to directory defined in IN.QUEUE.DIR field of OFS.SOURCE record
* EN_10001999 S
*      IF OFS$GLOBMAN.ACTIVE > 0 THEN
    IF OFS$GLOBMAN.ACTIVE GT 0 AND OFS$SOURCE.ID EQ K.OFS.SOURCE THEN
* EN_10001999 E
* Handle recursive calls to the same application.
        IF APPLICATION EQ FIELD(OFS.MESSAGE,COMP.SEP,1) THEN
            OFS$GLOBMAN.ACTIVE = 0
            RETURN
        END

        IN.QUEUE.DIR = OFS$SOURCE.REC<OFS.SRC.IN.QUEUE.DIR>
        CHANGE "\" TO "/" IN IN.QUEUE.DIR ;*R22 AUTO CONVERSTION CONVERT TO CHANGE
        NO.SEPS = COUNT(IN.QUEUE.DIR,"/")
        TEMP.FILE = FIELD(IN.QUEUE.DIR,"/",NO.SEPS+1)
        IF NOT(NO.SEPS) THEN
            TEMP.FILE = IN.QUEUE.DIR
        END

        OPEN TEMP.FILE TO F.TEMP.FILE ELSE
            ETEXT ="OF.RTN.OF.SRC.INVALID.PATH"
            RETURN
        END

        DA.TEMP.FILE = ""
        STATUS DA.TEMP.FILE FROM F.TEMP.FILE ELSE NULL
        FILE.TYPE = DA.TEMP.FILE<21>
        IF NOT(FILE.TYPE MATCHES "1":@VM:"19":@VM:"UD") THEN
            ETEXT ="OF.RTN.OF.SRC.FILE.TYPE"
            RETURN
        END

        CUR.TIME = TIME() "R%5"
        K.TEMP.FILE = OPERATOR : "." : CUR.TIME : DATE()
        WRITE OFS.MESSAGE ON F.TEMP.FILE,K.TEMP.FILE
        OFS$GLOBMAN.ACTIVE = 0
        RETURN
    END
    OFS$SOURCE.ID = K.OFS.SOURCE        ;* EN_10001999 S/E
    GOSUB CLEAR.ALL.ORG

    GOSUB PRESERVE.COMMON

    IF INDEX(TTYPE,"GUI",1) THEN
* Perform OFS operations using GLOBUS CLASSIC functionality
        TTYPE = ""
    END

    OFS$GLOBMAN.ACTIVE = 1    ;* OFS.GLOBUS.MANAGER active

    OFS$ACTIVE.MSG.REF = ''   ;* By-pass unique message reference checks   ; * GLOBUS_BG_100006633

    OFS$BROWSER = ''          ;* Initialise OFS$BROWSER to null before processing vanilla ofs messages

    IF NOT(TEST.MODE) THEN
        CALL HUSHIT(1) ;*R22 AUTO CONVERSTION HUSH ON TO CALL HUSHIT(1)
    END

    TXN.REF = ''
    CALL OFS.REQUEST.MANAGER(OFS.MESSAGE,TXN.REF)
    IF NOT(TEST.MODE) THEN
        CALL HUSHIT(0) ;*R22 AUTO CONVERSTION HUSH OF TO CALL HUSHIT(0)
    END
    IF OFS.MESSAGE NE '' THEN
        OFS.MESSAGE.DEL = OFS.MESSAGE   ;* set the OFS message to a common variable(BG_100016086)
    END
*
** See if it worked or not
*
    GOSUB DETERMINE.SUCCESS.OR.FAIL
*
    IF C$USE.T24.LOG THEN     ;* If T24 level logging is enabled
        OPEN.LOG = FILEINFO(OFS$LOG.FILE.NAME,0)  ;* See if we have a log file open
        IF OPEN.LOG THEN
            CLOSESEQ OFS$LOG.FILE.NAME  ;* close opened log file
        END
    END
    GOSUB RESTORE.APP

    OFS$GLOBMAN.ACTIVE = 0    ;* OFS Globus Manager inactive

RETURN

*************************************************************************
INITIALISE:
** Allow this to be called when the application is set up properly
** using JOURNAL.BYPASS. Validate calls should also be permitted
*

    DEFAULT.RECORD.TYPE = K.OFS.SOURCE<2>
    CALLING.PRODUCT = K.OFS.SOURCE<3>
    OFS$OGM.MAINTAIN.CACHE = K.OFS.SOURCE<4>      ;* maintain the cache for all child transaction ,calling routine need to call JUJ when they set it
    K.OFS.SOURCE = K.OFS.SOURCE<1>      ;* Strip out the additional values
    COMP.SEP = ","  ;* OFS Message Component Separator
    SUB.COMP.SEP = "/"        ;* Sub component separator
    SUCCESS.FAIL = ''         ;* Set based on result of request
    VALIDATE.OR.PROCESS = OFS.MESSAGE[COMP.SEP,2,1]
    VALIDATE.OR.PROCESS = VALIDATE.OR.PROCESS[SUB.COMP.SEP,3,1]
*
** Normally anything in the CACHE means we can't use OGM as we will
** cause havoc with transaction management
** But when we know what we are doing it's okay to use in VALIDATE mode
** or with JOURNAL.BYPASS set as we will commit as part of a bigger
** transaction
** We indicate we know what we're doing by setting CALLING.PRODUCT to AA
*
* Perform cache check is skipped when it is called by AA Routines or when Journal.Bypass
* is set or when it is in validation mode.
    BEGIN CASE
        CASE CALLING.PRODUCT AND CALLING.PRODUCT EQ "AA"        ;* if called by AA routines
            PERFORM.CACHE.CHECK = ""        ;* set cache check to false
        CASE JOURNAL.BYPASS OR VALIDATE.OR.PROCESS EQ "VALIDATE"          ;* if journal.bypass set or called in validate mode
            PERFORM.CACHE.CHECK = ""        ;* Set Cache check to false
        CASE OFS$OGM.MAINTAIN.CACHE         ;* maintain the transaction caches
            PERFORM.CACHE.CHECK = ""        ;* Set Cache check to false
        CASE 1
            PERFORM.CACHE.CHECK = "1"       ;* All other cases Perform cache check
    END CASE
*
    IF PERFORM.CACHE.CHECK THEN
        WRITE.PRESENT = ''
        CALL CHECK.CACHE.WRITE(WRITE.PRESENT)
        IF WRITE.PRESENT THEN
            TEXT = 'Write Cache Not Empty Cannot use OFS.GLOBUS.MANAGER'
            CALL FATAL.ERROR(TEXT)
        END
    END

* GLOBUS_BG_100004988 S - Save the Common OFS.SOURCE details before we overwrite them
    OFS$SOURCE.ID.ORG = OFS$SOURCE.ID
    OFS$SOURCE.REC.ORG = OFS$SOURCE.REC
    SOURCE.TYPE.ORG = OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE>
* GLOBUS_BG_100004988 E

    OFS.ONLINE.PROCESS = 0
    IF SOURCE.TYPE.ORG EQ "TELNET" OR SOURCE.TYPE.ORG EQ "SESSION" THEN ;* GLOBUS_BG_100004988
        OFS.ONLINE.PROCESS = 1          ;* OFS TELNET process.
    END

    ER = '' ; OFS$SOURCE.REC = ''
    CALL CACHE.READ("F.OFS.SOURCE",K.OFS.SOURCE,OFS$SOURCE.REC,ER)
    IF ER THEN
        IF DEFAULT.RECORD.TYPE THEN     ;* If a default record type is supplied build it in memory
            GOSUB LOAD.DEFAULT.OFS.SOURCE
        END
    END
* EN_10001999 E
    SOURCE.TYPE = OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE>
    LOG.LEVEL = ""
    IF C$USE.T24.LOG THEN     ;* If T24 level logging is enabled
        GOSUB OPEN.LOG.FILE   ;* Open log file
    END
    IF OFS$SOURCE.REC<OFS.SRC.LOG.DETAIL.LEVEL> EQ 'FULL' THEN
        LOG.LEVEL = 4
    END
*
    TEST.MODE = (APPLICATION = "SEAT.COMPONENT.TEST")
*

    DIM R.VERSION.ORG(C$SYSDIM)
    DIM CHECKFILE.ORG(C$SYSDIM)
    DIM R.COMPANY.ORG(C$SYSDIM)
    DIM CONCATFILE.ORG(C$SYSDIM)
    DIM R.DATES.ORG(C$SYSDIM)
    DIM F.ORG(C$SYSDIM)
    DIM N.ORG(C$SYSDIM)
    DIM R.NEW.ORG(C$SYSDIM)
    DIM R.NEW.LAST.ORG(C$SYSDIM)
    DIM R.OLD.ORG(C$SYSDIM)
    DIM R.ORG(C$SYSDIM)
    DIM T.ORG(C$SYSDIM)
    DIM T.REMTEXT.ORG(C$SYSDIM)
    DIM C$SPARE.ORG(C$SYSDIM)
    DIM FWC.ORG(R.SPF.SYSTEM<SPF.CACHE.SIZE>)
    DIM FWC.NEW(R.SPF.SYSTEM<SPF.CACHE.SIZE>)
    DIM FWF.ORG(R.SPF.SYSTEM<SPF.CACHE.SIZE>)
    DIM FWF.NEW(R.SPF.SYSTEM<SPF.CACHE.SIZE>)
    DIM BRANCH.FVAR.ORG(300)
    DIM BRANCH.FVAR.NEW(200)
    DIM FVAR.ORG(500)
    DIM FVAR.NEW(500)
    DIM TEMP$C_ACTIONS(20)
    DIM TEMP$C_ROUTINES(20)


    IF UNASSIGNED(OFS$GLOBMAN.ACTIVE) THEN
        OFS$GLOBMAN.ACTIVE = 0          ;* OFS.GLOBUS.MANAGER Inactive
    END

    ENC$ENCRYPT.FLAG = ''     ;*  Initialise ENC$ENCRYPT.FLAG common variable to null

RETURN
*
*-----------------------------------------------------------------------------
OPEN.LOG.FILE:
*============
* Open log file directory
    OFS$LOG.FILE.NAME = ""
    LOG.DET.LEVEL = OFS$SOURCE.REC<OFS.SRC.LOG.DETAIL.LEVEL>
    IF LOG.DET.LEVEL NE "" AND LOG.DET.LEVEL NE "NONE" THEN ;* Log detail level of OFS.SOURCE is set except 'NONE'
        SEQ.FILEN = OFS$SOURCE.REC<OFS.SRC.LOG.FILE.DIR>

        K.LOG.FILE = K.OFS.SOURCE : "-" : OPERATOR
        OPENSEQ SEQ.FILEN,K.LOG.FILE TO OFS$LOG.FILE.NAME ELSE        ;* open log file
            CREATE OFS$LOG.FILE.NAME ELSE         ;* create log file if not done before
                ETEXT ="OF.RTN.OF.SRC.INVALID.PATH"
                RETURN
            END
        END
        SEEK OFS$LOG.FILE.NAME,0,2 ELSE NULL      ;* Move to end of file
        OFS$SOURCE.ID.BACKUP = K.OFS.SOURCE       ;* Get the back up of the Current ofs source id in K.OFS.SOURCE to OFS$SOURCE.ID.BACKUP
    END

RETURN
*
*-----------------------------------------------------------------------------
DETERMINE.SUCCESS.OR.FAIL:
*=========================
** Check the return message to see if it worked
** 1 was a success
** -1 fail
** -2 fail put in HLD
** -3 offline written to queue
*
    FIRST.MSG.BIT = OFS.MESSAGE[COMP.SEP,1,1]
    SUCCESS.FAIL = FIRST.MSG.BIT[SUB.COMP.SEP,3,1]
*
** Now figure out what to do with the cache in case of error
** We'll need to put the cache back for a full error
** for HOLD we need to include the hold write only
*
    BEGIN CASE
        CASE VALIDATE.OR.PROCESS EQ 'VALIDATE'
            GOSUB RESTORE.CACHE   ;* Validate must put back the old cache
        CASE (SUCCESS.FAIL EQ 1 AND JOURNAL.BYPASS)  OR WRITE.CACHE        ;* leave the cache as it is.If WRITE.CACHE is set,dont't restore the cache.
        CASE SUCCESS.FAIL = 1     ;* Restore the cache - shouldn't get here with cache
            GOSUB RESTORE.CACHE
        CASE SUCCESS.FAIL = -1    ;* Failure no updates
            GOSUB RESTORE.CACHE
        CASE SUCCESS.FAIL = -2 AND JOURNAL.BYPASS     ;* Hold due to error
            GOSUB MERGE.CACHE     ;* Put back previous updates - need to add HLD
**
** The cache should contain the HLD update only so merge this
**
        CASE SUCCESS.FAIL = -2    ;* Nothing to restore
            GOSUB RESTORE.CACHE
        CASE SUCCESS.FAIL = -3 AND JOURNAL.BYPASS     ;* Offline queue
            GOSUB RESTORE.CACHE
        CASE SUCCESS.FAIL = -3
    END CASE
*
RETURN
*
*-----------------------------------------------------------------------------
RESTORE.CACHE:
*=============
*
    IF NOT(OFS$OGM.MAINTAIN.CACHE) THEN ;* Dont resore the cache
        FWT = FWT.ORG
        MAT FWC = MAT FWC.ORG
        MAT FWF = MAT FWF.ORG
        MAT BRANCH.FVAR = MAT BRANCH.FVAR.ORG
        MAT FVAR = MAT FVAR.ORG
    END
*
RETURN
*
*-----------------------------------------------------------------------------
SAVE.CACHE:
*
    IF NOT(OFS$OGM.MAINTAIN.CACHE) THEN ;* Dont save the cache
        FWT.ORG = FWT
        MAT FWC.ORG = MAT FWC
        MAT FWF.ORG = MAT FWF
        MAT BRANCH.FVAR.ORG = MAT BRANCH.FVAR
        MAT FVAR.ORG = MAT FVAR
    END
*
RETURN
*
*-----------------------------------------------------------------------------
MERGE.CACHE:
*
** Take the cache prior to the transaction and merge the new values back
** this will take care of an application that has an error and is put on
** HLD status- The HLD write will be added
**
** Firt store what's currently in the cache - this will be the last update
*
    IF NOT(OFS$OGM.MAINTAIN.CACHE) THEN ;* Dont merge the cache
        NEW.FWT = FWT
        MAT FWC.NEW = MAT FWC
        MAT FWF.NEW = MAT FWF
        MAT BRANCH.FVAR.NEW = MAT BRANCH.FVAR
        MAT FVAR.NEW = MAT FVAR
*
** Now put back the previous cache
*
        GOSUB RESTORE.CACHE
    END

*
** Now add the new to the restored
*
RETURN
*
*-----------------------------------------------------------------------------
*
PRESERVE.COMMON:
*
*Arrays
*
    GOSUB SAVE.CACHE
*
    MAT CHECKFILE.ORG = MAT CHECKFILE
    MAT R.COMPANY.ORG = MAT R.COMPANY
    MAT CONCATFILE.ORG = MAT CONCATFILE
    MAT R.DATES.ORG = MAT R.DATES
    MAT F.ORG = MAT F
    MAT N.ORG = MAT N
    MAT R.NEW.ORG = MAT R.NEW
    MAT R.NEW.LAST.ORG = MAT R.NEW.LAST
    MAT R.OLD.ORG = MAT R.OLD
    MAT R.ORG = MAT R
    MAT T.ORG = MAT T
    MAT T.REMTEXT.ORG = MAT T.REMTEXT
    MAT C$SPARE.ORG = MAT C$SPARE
    MAT R.VERSION.ORG = MAT R.VERSION
*
    BRANCH.MNEMONIC.ORG = BRANCH.MNEMONIC
    CCY.TABLE.ORG = CCY.TABLE
    BRANCH.POSITION.ORG = BRANCH.POSITION
    A.ORG = A
    AF.ORG = AF
    AUTH.NO.ORG = AUTH.NO
    ANY.INPUT.ORG = ANY.INPUT
    APPLICATION.ORG = APPLICATION
    AS.ORG = AS
    F.JOURNAL.ORG = F.JOURNAL
    AUTH.QUALITY.ORG = AUTH.QUALITY
    AV.ORG = AV
    C.ORG = C
    COMI.ORG = COMI
    COMI.ENRI.ORG = COMI.ENRI
    CONTROLWORD.OK.ORG = CONTROLWORD.OK
    PRT.PARAMS.ORG = PRT.PARAMS
    V$DISPLAY.ORG = V$DISPLAY
    E.ORG = E
    ECOMI.ORG = ECOMI
    END.ERROR.ORG = END.ERROR
    ETEXT.ORG = ETEXT
    FILE.TYPE.ORG = FILE.TYPE
    FULL.FNAME.ORG = FULL.FNAME
    V$FUNCTION.ORG = V$FUNCTION
    HIST.NO.ORG = HIST.NO
    ID.ALL.ORG = ID.ALL
    ID.AUT.ORG = ID.AUT
    ID.CHECKFILE.ORG = ID.CHECKFILE
    R.INTERCO.PARAMETER.ORG = R.INTERCO.PARAMETER
    ID.COMPANY.ORG = ID.COMPANY
    ID.CONCATFILE.ORG = ID.CONCATFILE
    ID.ENRI.ORG = ID.ENRI
    ID.ETEXT.ORG = ID.ETEXT
    ID.F.ORG = ID.F
    ID.N.ORG = ID.N
    ID.NEW.ORG = ID.NEW
    ID.NEW.LAST.ORG = ID.NEW.LAST
    ID.OLD.ORG = ID.OLD
    ID.POINTER.ORG = ID.POINTER
    ID.R.ORG = ID.R
    ID.T.ORG = ID.T
    JOURNAL.BYPASS.ORG = JOURNAL.BYPASS
    INPUT.BUFFER.ORG = INPUT.BUFFER     ;* GLOBUS_BG_100006476
    L.ORG = L
    L.MULTI.ORG = L.MULTI
    L1ST.ORG = L1ST
    LASTA.ORG = LASTA
    LASTL.MULTI.ORG = LASTL.MULTI
    OVERRIDE.FLAG.ORG = OVERRIDE.FLAG
    LASTP.ORG = LASTP
    LCCY.ORG = LCCY
    LEVEL.NO.ORG = LEVEL.NO
    LEVEL.STATUS.ORG = LEVEL.STATUS
    LNGG.ORG = LNGG
    LOCAL.REF.FIELD.ORG = LOCAL.REF.FIELD
    MESSAGE.ORG = MESSAGE
    MULTI.POSSIBLE.ORG = MULTI.POSSIBLE
    MTHPOS.ORG = MTHPOS
    P.ORG = P
    PGM.TYPE.ORG = PGM.TYPE
    PGM.TYPE.NEXT.ORG = PGM.TYPE.NEXT
    PGM.VERSION.ORG = PGM.VERSION
    PHNO.ORG = PHNO
    PREFIX.ORG = PREFIX
    PRINTER.STATUS.ORG = PRINTER.STATUS
    RETURN.COMI.ORG = RETURN.COMI
    SCREEN.MODE.ORG = SCREEN.MODE
    SCREEN.TITLE.ORG = SCREEN.TITLE
    T.OV.CLASS.ORG = T.OV.CLASS
    TEXT.ORG = TEXT
    TIME.STAMP.ORG = TIME.STAMP
    TNO.ORG = C$T24.SESSION.NO  ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    TODAY.ORG = TODAY
    R.ACCOUNT.PARAMETER.ORG = R.ACCOUNT.PARAMETER
    TTYPE.ORG = TTYPE
    V.ORG = V
    VAL.TEXT.ORG = VAL.TEXT
    T.AUTH.PAGE.ORG = T.AUTH.PAGE
    R.SPF.SYSTEM.ORG = R.SPF.SYSTEM
    T.CAT.ORG = T.CAT
    T.CCY.ORG = T.CCY
    CLEAR.SCREEN.ORG = CLEAR.SCREEN
    T.CONTROLWORD.ORG = T.CONTROLWORD
    T.ENRI.ORG = T.ENRI
    T.ETEXT.ORG = T.ETEXT
    T.FIELDNO.ORG = T.FIELDNO
    T.FUNCTION.ORG = T.FUNCTION
    T.LANGUAGE.ORG = T.LANGUAGE
    FILE.CLASS.ORG = FILE.CLASS
    CACHE.OFF.ORG = CACHE.OFF
    T.LOCREF.ORG = T.LOCREF
    T.MTH.ORG = T.MTH
    T.MTH.DAY.ORG = T.MTH.DAY
    T.MULTI.PAGE.ORG = T.MULTI.PAGE
    F.SPF.ORG = F.SPF
    CONTROL.MODULO.ORG = CONTROL.MODULO
    LEVELS.NOT.ALLOWED.ORG = LEVELS.NOT.ALLOWED
    T.MULTI.TEXT.ORG = T.MULTI.TEXT
    LIMIT.NETTING.IND.ORG = LIMIT.NETTING.IND
    T.PWD.ORG = T.PWD
    T.PWP.ORG = T.PWP
    T.RAT.ORG = T.RAT
    T.RETURN.DATA.ORG = T.RETURN.DATA
    T.SEQU.ORG = T.SEQU
    T.SUB.ASSOC.ORG = T.SUB.ASSOC
    BATCH.DETAILS.ORG = BATCH.DETAILS
    T.TRS.ORG = T.TRS
    CACHE.TEXT.TABLE.ORG = CACHE.TEXT.TABLE
    F.ACTIVITY.ORG = F.ACTIVITY
    F.FILE.ORG = F.FILE
    F.FILE$HIS.ORG = F.FILE$HIS
    F.FILE$NAU.ORG = F.FILE$NAU
    F.LOCKING.ORG = F.LOCKING
    F.PROTOCOL.ORG = F.PROTOCOL
    F.CURRENCY.ORG = F.CURRENCY
    LIVE.RECORD.MANDATORY.ORG = LIVE.RECORD.MANDATORY
    LANG.NO.ORG = LANG.NO
    F.DYNAMIC.TEXT.ORG = F.DYNAMIC.TEXT
    F.STATIC.TEXT.ORG = F.STATIC.TEXT
    F.FILE.CONTROL.ORG = F.FILE.CONTROL
    T.VAL.ASSOC.ORG = T.VAL.ASSOC
    LOCAL1.ORG = LOCAL1
    LOCAL2.ORG = LOCAL2
    LOCAL3.ORG = LOCAL3
    LOCAL4.ORG = LOCAL4
    F.IDS.LATEST.ORG = F.IDS.LATEST
    RUNNING.UNDER.BATCH.ORG = RUNNING.UNDER.BATCH
    T.DEF.BASE.ORG = T.DEF.BASE
    T.DEF.BASE.TARGET.ORG = T.DEF.BASE.TARGET
    COMI.DEFAULT.ORG = COMI.DEFAULT
    CMD$STACK.ORG = CMD$STACK
    T.SELECT.ORG = T.SELECT
    LINK.DATA.ORG = LINK.DATA

* Preserve the named common:  GLOBUS1
    R.USER.ORG = R.USER
    C$INT.MOVEMENT.PARAM.ORG = C$INT.MOVEMENT.PARAM
    R.BANK.RETURN.PARAMS.ORG = R.BANK.RETURN.PARAMS
    C$.UNIVERSE.RELEASE.ORG = C$.UNIVERSE.RELEASE
    C$.USE.CCY.CACHE.ORG = C$.USE.CCY.CACHE
    C$R.LCCY.ORG = C$R.LCCY
    C$BA.PARAMETER.ORG = C$BA.PARAMETER
    C$EB.PHANTOM.ID.ORG = C$EB.PHANTOM.ID
    C$PC.CLOSING.DATE.ORG = C$PC.CLOSING.DATE
    RUNNING.IN.JBASE.ORG = RUNNING.IN.JBASE
    USING.EBCDIC.ORG = USING.EBCDIC
    C$SEQX.ORG = C$SEQX

* Preserve the named common:  V$GTS
    GTSACTIVE.ORG = GTSACTIVE
    GTSSTAGE.ORG = GTSSTAGE
    R.GTS.ORG = R.GTS
    GTSMODE.ORG = GTSMODE
    GTSERROR.ORG = GTSERROR
    R.GT.PARM.ORG = R.GT.PARM
    ERR.TEXTS.ORG = ERR.TEXTS
    ENR.TEXTS.ORG = ENR.TEXTS
    MASKS.ORG = MASKS
    GTSUSER.ORG = GTSUSER
    GTSCOMPANY.ORG = GTSCOMPANY
    GTSDEPT.ORG = GTSDEPT
    TERM.CHAR.ORG = TERM.CHAR
    DELM.CHAR.ORG = DELM.CHAR
    LOG.LEVEL.ORG = LOG.LEVEL
    F.LOG.ORG = F.LOG
    GTS.DC.DEPT.ORG = GTS.DC.DEPT
    GTS.DC.BATCH.ORG = GTS.DC.BATCH
    GTS.DC.ITEM.ORG = GTS.DC.ITEM
    OFS.VAL.ONLY.ORG = OFS.VAL.ONLY
    OFS.ALIAS.ORG = OFS.ALIAS
    IF C$USE.T24.LOG THEN     ;* If T24 level logging is enabled
        OFS$LOG.FILE.NAME.ORG = OFS$LOG.FILE.NAME ;* preserve T24 log file directory common
    END
* Preserve Browser Vars
    OFS$GLOBMAN.ACTIVE.ORG = OFS$GLOBMAN.ACTIVE
    OFS$OVERRIDES.ORG = OFS$OVERRIDES
    OFS$WARNINGS.ORG = OFS$WARNINGS     ;* GLOBUS_EN_10002369
    OFS$PREVIOUS.ENQS.ORG = OFS$PREVIOUS.ENQS     ;* GLOBUS_BG_100008069
    OFS$PREVIOUS.ENQ.TITLES.ORG = OFS$PREVIOUS.ENQ.TITLES   ;* GLOBUS_EN_10003742
    OFS$GETRECORD.ORG = OFS$GETRECORD
    OFS$NEWRECORD.ORG = OFS$NEWRECORD
    OFS$ETEXT.ORG = OFS$ETEXT
    OFS$EXPANSION.DETAILS.ORG = OFS$EXPANSION.DETAILS
    OFS$MESSAGE.TEXT.ORG = OFS$MESSAGE.TEXT
    OFS$OPERATION.ORG = OFS$OPERATION
    OFS$SAVE.CONTEXT.ORG = OFS$SAVE.CONTEXT
    OFS$ACTIVE.TAB.ORG = OFS$ACTIVE.TAB
    OFS$NEW.OVERRIDES.ORG = OFS$NEW.OVERRIDES
    OFS$STORED.OVERRIDES.ORG = OFS$STORED.OVERRIDES
    OFS$NEW.WARNINGS.ORG = OFS$NEW.WARNINGS       ;* GLOBUS_EN_10002369
    OFS$STORED.WARNINGS.ORG = OFS$STORED.WARNINGS ;* GLOBUS_EN_10002369
    OFS$GET.SEE.LOCK.ORG = OFS$GET.SEE.LOCK
    OFS$NEXT.COMMAND.ORG = OFS$NEXT.COMMAND
    OFS$NEW.COMMAND.ORG = OFS$NEW.COMMAND         ;* GLOBUS_EN_10002665
    OFS$WINDOW.NAME.ORG = OFS$WINDOW.NAME
    OFS$TOOLBAR.DEFINITIONS.ORG = OFS$TOOLBAR.DEFINITIONS
    OFS$TOOL.DEFINITIONS.ORG = OFS$TOOL.DEFINITIONS
    OFS$TOOLBAR.TARGET.ORG = OFS$TOOLBAR.TARGET
    OFS$ENRI.ORG = OFS$ENRI
    OFS$ROUTINE.ARGS.ORG = OFS$ROUTINE.ARGS
    OFS$TXN.COMPLETE.ORG = OFS$TXN.COMPLETE
    OFS$SUPRESS.TXN.COMPLETE.ORG = OFS$SUPRESS.TXN.COMPLETE
    OFS$BROWSER.MESSAGES.ORG = OFS$BROWSER.MESSAGES
    OFS$ACTIVE.MSG.REF.ORG = OFS$ACTIVE.MSG.REF
    OFS$GETTING.ID.ORG = OFS$GETTING.ID
    OFS$DEAL.SLIP.PRINTING.ORG = OFS$DEAL.SLIP.PRINTING
    OFS$CLEAR.INPUT.FIELD.ORG = OFS$CLEAR.INPUT.FIELD
    OFS$HOT.FIELD.ORG = OFS$HOT.FIELD
    OFS$QUEUE.REC.ORG = OFS$QUEUE.REC
    OFS$EB.ATTRIBUTES.CACHE.ORG = OFS$EB.ATTRIBUTES.CACHE
    OFS$REGISTER.CONTRACT.ERRORS.ORG = OFS$REGISTER.CONTRACT.ERRORS
    OFS$EXPANSION.FOCUS.ORG = OFS$EXPANSION.FOCUS
    OFS$BROWSER.HOLD.ORG = OFS$BROWSER.HOLD
    OFS$CLIENT.PRINT.ORG = OFS$CLIENT.PRINT
    OFS$PRINTER.LOCATION.ORG = OFS$PRINTER.LOCATION
    OFS$STYLE.SHEET.ORG = OFS$STYLE.SHEET
    OFS$MESSAGE.ORG = OFS$MESSAGE       ;* GLOBUS_GB_100009416
    OFS$STATUS.ORG = OFS$STATUS         ;* GLOBUS_BG_100010080 S
    OFS$PASSBOOK.DETAILS.ORG = OFS$PASSBOOK.DETAILS
    OFS$PASSBOOK.PRINT.PROMPTS.ORG = OFS$PASSBOOK.PRINT.PROMPTS
    OFS$PASSBOOK.PRINT.STAGE.ORG = OFS$PASSBOOK.PRINT.STAGE
    OFS$PASSBOOK.CONTEXT.ORG = OFS$PASSBOOK.CONTEXT         ;* GLOBUS_BG_100010080 E
    OFS$BROWSER.ORG = OFS$BROWSER       ;* Save OFS$BROWSER common variable
    OFS$VERSION.FLD.ORG = OFS$VERSION.FLD         ;* Save OFS$VERSION variable
*
** Preserve new template variables
*
    TEMP$C_PROPERTIES = C_PROPERTIES
    TEMP$C_METHODS = C_METHODS
    TEMP$C_INPUTS = C_INPUTS
    TEMP$C_NOINPUTS = C_NOINPUTS
    MAT TEMP$C_ROUTINES = MAT C_ROUTINES
    MAT TEMP$C_ACTIONS = MAT C_ACTIONS
*
RETURN
*
*-----------------------------------------------------------------------------
*
CLEAR.ALL.ORG:
*
*Arrays
*
    MAT R.VERSION.ORG = ""
    MAT CHECKFILE.ORG = ""
    MAT R.COMPANY.ORG = ""
    MAT CONCATFILE.ORG = ""
    MAT R.DATES.ORG = ""
    MAT F.ORG = ""
    MAT N.ORG = ""
    MAT R.NEW.ORG = ""
    MAT R.NEW.LAST.ORG = ""
    MAT R.OLD.ORG = ""
    MAT R.ORG = ""
    MAT T.ORG = ""
    MAT T.REMTEXT.ORG = ""
    MAT C$SPARE.ORG = ""

*
* Simple fields
*
    AF.ORG = ""
    AV.ORG = ""
    AS.ORG = ""
    ID.NEW.ORG = ""
    ID.NEW.LAST.ORG = ""
    ID.OLD.ORG = ""
    F.FILE.ORG = ""
    APPLICATION.ORG = ""
    T.LOCREF.ORG = ""
    FWT.ORG = ""

RETURN
*
*-----------------------------------------------------------------------------
*
RESTORE.APP:

    IF INDEX(TTYPE,"GUI",1) EQ 0 THEN
        V$FUNCTION = "DUMMY"
        PROG.NAME = APPLICATION
        IF PROG.NAME NE "" AND PROG.NAME NE "ENQUIRY.SELECT" AND NOT(PGM.TYPE[1,1] MATCHES 'M':@VM:'D') THEN   ;* Do not call EB.EXECUTE.APPLICATION if OFS enquiry request is processed
            CALL EB.EXECUTE.APPLICATION(APPLICATION)
            CALL MATRIX.UPDATE
        END
    END

    GOSUB RESTORE.COMMON

* If this is a CLASSIC session & not an OFS Online process
* repaint the original screen.

    IF NOT(OFS.ONLINE.PROCESS) THEN
        IF INDEX(TTYPE,"GUI",1) EQ 0 THEN
            CALL STANDARD.DISPLAY
            CALL REBUILD.SCREEN
        END
    END

* Prepare for a move to the next field on the input screen.
    T.SEQU<-1> = AF + 1

RETURN
*
*-----------------------------------------------------------------------------
*
RESTORE.COMMON:
*
*Arrays
*
    MAT R.VERSION = MAT R.VERSION.ORG
    MAT CHECKFILE = MAT CHECKFILE.ORG
    MAT R.COMPANY = MAT R.COMPANY.ORG
    MAT CONCATFILE = MAT CONCATFILE.ORG
    MAT R.DATES = MAT R.DATES.ORG
    MAT F = MAT F.ORG
    MAT N = MAT N.ORG
    MAT R.NEW = MAT R.NEW.ORG
    MAT R.NEW.LAST = MAT R.NEW.LAST.ORG
    MAT R.OLD = MAT R.OLD.ORG
    MAT R = MAT R.ORG
    MAT T = MAT T.ORG
    MAT T.REMTEXT = MAT T.REMTEXT.ORG
    MAT C$SPARE = MAT C$SPARE.ORG
    CCY.TABLE = CCY.TABLE.ORG
    BRANCH.MNEMONIC = BRANCH.MNEMONIC.ORG
    BRANCH.POSITION = BRANCH.POSITION.ORG
    A = A.ORG
    AF = AF.ORG
    AUTH.NO = AUTH.NO.ORG
    ANY.INPUT = ANY.INPUT.ORG
    APPLICATION = APPLICATION.ORG
    AS = AS.ORG
    F.JOURNAL = F.JOURNAL.ORG
    AUTH.QUALITY = AUTH.QUALITY.ORG
    AV = AV.ORG
    C = C.ORG
    COMI = COMI.ORG
    COMI.ENRI = COMI.ENRI.ORG
    CONTROLWORD.OK = CONTROLWORD.OK.ORG
    PRT.PARAMS = PRT.PARAMS.ORG
    V$DISPLAY = V$DISPLAY.ORG
    E = E.ORG
    ECOMI = ECOMI.ORG
    END.ERROR = END.ERROR.ORG
    ETEXT = ETEXT.ORG
    FILE.TYPE = FILE.TYPE.ORG
    FULL.FNAME = FULL.FNAME.ORG
    V$FUNCTION = V$FUNCTION.ORG
    HIST.NO = HIST.NO.ORG
    ID.ALL = ID.ALL.ORG
    ID.AUT = ID.AUT.ORG
    ID.CHECKFILE = ID.CHECKFILE.ORG
    R.INTERCO.PARAMETER = R.INTERCO.PARAMETER.ORG
    ID.CONCATFILE = ID.CONCATFILE.ORG
    ID.ENRI = ID.ENRI.ORG
    ID.ETEXT = ID.ETEXT.ORG
    ID.F = ID.F.ORG
    ID.N = ID.N.ORG
    ID.NEW = ID.NEW.ORG
    ID.NEW.LAST = ID.NEW.LAST.ORG
    ID.OLD = ID.OLD.ORG
    ID.POINTER = ID.POINTER.ORG
    ID.R = ID.R.ORG
    ID.T = ID.T.ORG
    JOURNAL.BYPASS = JOURNAL.BYPASS.ORG
    INPUT.BUFFER = INPUT.BUFFER.ORG     ;* GLOBUS_BG_100006476
    L = L.ORG
    L.MULTI = L.MULTI.ORG
    L1ST = L1ST.ORG
    LASTA = LASTA.ORG
    LASTL.MULTI = LASTL.MULTI.ORG
    OVERRIDE.FLAG = OVERRIDE.FLAG.ORG
    LASTP = LASTP.ORG
    LCCY = LCCY.ORG
    LEVEL.NO = LEVEL.NO.ORG
    LEVEL.STATUS = LEVEL.STATUS.ORG
    LNGG = LNGG.ORG
    LOCAL.REF.FIELD = LOCAL.REF.FIELD.ORG
    MESSAGE = MESSAGE.ORG
    MULTI.POSSIBLE = MULTI.POSSIBLE.ORG
    MTHPOS = MTHPOS.ORG
    P = P.ORG
    PGM.TYPE = PGM.TYPE.ORG
    PGM.TYPE.NEXT = PGM.TYPE.NEXT.ORG
    PGM.VERSION = PGM.VERSION.ORG
    PHNO = PHNO.ORG
    PREFIX = PREFIX.ORG
    PRINTER.STATUS = PRINTER.STATUS.ORG
    RETURN.COMI = RETURN.COMI.ORG
    SCREEN.MODE = SCREEN.MODE.ORG
    SCREEN.TITLE = SCREEN.TITLE.ORG
    T.OV.CLASS = T.OV.CLASS.ORG
    TEXT = TEXT.ORG
    TIME.STAMP = TIME.STAMP.ORG
    C$T24.SESSION.NO = TNO.ORG  ;*R22 AUTO CONVERSTION TNO TO C$T24.SESSION.NO
    TODAY = TODAY.ORG
    R.ACCOUNT.PARAMETER = R.ACCOUNT.PARAMETER.ORG
    TTYPE = TTYPE.ORG
    V = V.ORG
    VAL.TEXT = VAL.TEXT.ORG
    T.AUTH.PAGE = T.AUTH.PAGE.ORG
    R.SPF.SYSTEM = R.SPF.SYSTEM.ORG
    T.CAT = T.CAT.ORG
    T.CCY = T.CCY.ORG
    CLEAR.SCREEN = CLEAR.SCREEN.ORG
    T.CONTROLWORD = T.CONTROLWORD.ORG
    T.ENRI = T.ENRI.ORG
    T.ETEXT = T.ETEXT.ORG
    T.FIELDNO = T.FIELDNO.ORG
    T.FUNCTION = T.FUNCTION.ORG
    T.LANGUAGE = T.LANGUAGE.ORG
    FILE.CLASS = FILE.CLASS.ORG
    CACHE.OFF = CACHE.OFF.ORG
    T.LOCREF = T.LOCREF.ORG
    T.MTH = T.MTH.ORG
    T.MTH.DAY = T.MTH.DAY.ORG
    T.MULTI.PAGE = T.MULTI.PAGE.ORG
    F.SPF = F.SPF.ORG
    CONTROL.MODULO = CONTROL.MODULO.ORG
    LEVELS.NOT.ALLOWED = LEVELS.NOT.ALLOWED.ORG
    T.MULTI.TEXT = T.MULTI.TEXT.ORG
    LIMIT.NETTING.IND = LIMIT.NETTING.IND.ORG
    T.PWD = T.PWD.ORG
    T.PWP = T.PWP.ORG
    T.RAT = T.RAT.ORG
    T.RETURN.DATA = T.RETURN.DATA.ORG
    T.SEQU = T.SEQU.ORG
    T.SUB.ASSOC = T.SUB.ASSOC.ORG
    BATCH.DETAILS = BATCH.DETAILS.ORG
    T.TRS = T.TRS.ORG
    CACHE.TEXT.TABLE = CACHE.TEXT.TABLE.ORG
    F.ACTIVITY = F.ACTIVITY.ORG
    F.FILE = F.FILE.ORG
    F.FILE$HIS = F.FILE$HIS.ORG
    F.FILE$NAU = F.FILE$NAU.ORG
    F.LOCKING = F.LOCKING.ORG
    F.PROTOCOL = F.PROTOCOL.ORG
    F.CURRENCY = F.CURRENCY.ORG
    LIVE.RECORD.MANDATORY = LIVE.RECORD.MANDATORY.ORG
    LANG.NO = LANG.NO.ORG
    F.DYNAMIC.TEXT = F.DYNAMIC.TEXT.ORG
    F.STATIC.TEXT = F.STATIC.TEXT.ORG
    F.FILE.CONTROL = F.FILE.CONTROL.ORG
    T.VAL.ASSOC = T.VAL.ASSOC.ORG
    LOCAL1 = LOCAL1.ORG
    LOCAL2 = LOCAL2.ORG
    LOCAL3 = LOCAL3.ORG
    LOCAL4 = LOCAL4.ORG
    F.IDS.LATEST = F.IDS.LATEST.ORG
    RUNNING.UNDER.BATCH = RUNNING.UNDER.BATCH.ORG
    T.DEF.BASE = T.DEF.BASE.ORG
    T.DEF.BASE.TARGET = T.DEF.BASE.TARGET.ORG
    COMI.DEFAULT = COMI.DEFAULT.ORG
    CMD$STACK = CMD$STACK.ORG
    T.SELECT = T.SELECT.ORG
    LINK.DATA = LINK.DATA.ORG

* Restore the named common:  GLOBUS1
    R.USER = R.USER.ORG
    C$INT.MOVEMENT.PARAM = C$INT.MOVEMENT.PARAM.ORG
    R.BANK.RETURN.PARAMS = R.BANK.RETURN.PARAMS.ORG
    C$.UNIVERSE.RELEASE = C$.UNIVERSE.RELEASE.ORG
    C$.USE.CCY.CACHE = C$.USE.CCY.CACHE.ORG
    C$R.LCCY = C$R.LCCY.ORG
    C$BA.PARAMETER = C$BA.PARAMETER.ORG
    C$EB.PHANTOM.ID = C$EB.PHANTOM.ID.ORG
    C$PC.CLOSING.DATE = C$PC.CLOSING.DATE.ORG
    RUNNING.IN.JBASE = RUNNING.IN.JBASE.ORG
    USING.EBCDIC = USING.EBCDIC.ORG
    C$SEQX = C$SEQX.ORG

* Restore Company Details if only it is a diffenrent than the original company
    IF ID.COMPANY NE ID.COMPANY.ORG THEN
        CALL LOAD.COMPANY(ID.COMPANY.ORG)
    END


* Restore the named common:  V$GTS
    GTSACTIVE = GTSACTIVE.ORG
    GTSSTAGE = GTSSTAGE.ORG
    R.GTS = R.GTS.ORG
    GTSMODE = GTSMODE.ORG
    GTSERROR = GTSERROR.ORG
    R.GT.PARM = R.GT.PARM.ORG
    ERR.TEXTS = ERR.TEXTS.ORG
    ENR.TEXTS = ENR.TEXTS.ORG
    MASKS = MASKS.ORG
    GTSUSER = GTSUSER.ORG
    GTSCOMPANY = GTSCOMPANY.ORG
    GTSDEPT = GTSDEPT.ORG
    TERM.CHAR = TERM.CHAR.ORG
    DELM.CHAR = DELM.CHAR.ORG
    LOG.LEVEL = LOG.LEVEL.ORG
    F.LOG = F.LOG.ORG
    GTS.DC.DEPT = GTS.DC.DEPT.ORG
    GTS.DC.BATCH = GTS.DC.BATCH.ORG
    GTS.DC.ITEM = GTS.DC.ITEM.ORG
    OFS.VAL.ONLY = OFS.VAL.ONLY.ORG
    OFS.ALIAS = OFS.ALIAS.ORG
    IF C$USE.T24.LOG THEN     ;* If T24 level logging is enabled
        OFS$LOG.FILE.NAME = OFS$LOG.FILE.NAME.ORG ;* Restore T24 log file directory common
    END
    OFS$SOURCE.ID = OFS$SOURCE.ID.ORG
    OFS$SOURCE.REC = OFS$SOURCE.REC.ORG

* Restore Browser Vars
    OFS$GLOBMAN.ACTIVE = OFS$GLOBMAN.ACTIVE.ORG
    OFS$OVERRIDES = OFS$OVERRIDES.ORG
    OFS$WARNINGS = OFS$WARNINGS.ORG     ;* GLOBUS_EN_10002369
    OFS$PREVIOUS.ENQS = OFS$PREVIOUS.ENQS.ORG     ;* GLOBUS_BG_100008069
    OFS$PREVIOUS.ENQ.TITLES = OFS$PREVIOUS.ENQ.TITLES.ORG   ;* GLOBUS_EN_10003742
    OFS$GETRECORD = OFS$GETRECORD.ORG
    OFS$NEWRECORD = OFS$NEWRECORD.ORG
    OFS$ETEXT = OFS$ETEXT.ORG
    OFS$EXPANSION.DETAILS = OFS$EXPANSION.DETAILS.ORG
    OFS$MESSAGE.TEXT = OFS$MESSAGE.TEXT.ORG
    OFS$OPERATION = OFS$OPERATION.ORG
    OFS$SAVE.CONTEXT = OFS$SAVE.CONTEXT.ORG
    OFS$ACTIVE.TAB = OFS$ACTIVE.TAB.ORG
    OFS$NEW.OVERRIDES = OFS$NEW.OVERRIDES.ORG
    OFS$STORED.OVERRIDES = OFS$STORED.OVERRIDES.ORG
    OFS$NEW.WARNINGS = OFS$NEW.WARNINGS.ORG       ;* GLOBUS_EN_10002369
    OFS$STORED.WARNINGS = OFS$STORED.WARNINGS.ORG ;* GLOBUS_EN_10002369
    OFS$GET.SEE.LOCK = OFS$GET.SEE.LOCK.ORG
    IF NOT(PW$FOLLOW.ON.ACT) THEN
        OFS$NEXT.COMMAND = OFS$NEXT.COMMAND.ORG       ;* EN_10002888 S/E
    END  ;*R22 AUTO CONVERSTION ADD END FOR IF
    OFS$NEW.COMMAND = OFS$NEW.COMMAND.ORG         ;* GLOBUS_EN_10002665
    OFS$WINDOW.NAME = OFS$WINDOW.NAME.ORG
    OFS$TOOLBAR.DEFINITIONS = OFS$TOOLBAR.DEFINITIONS.ORG
    OFS$TOOL.DEFINITIONS = OFS$TOOL.DEFINITIONS.ORG
    OFS$TOOLBAR.TARGET = OFS$TOOLBAR.TARGET.ORG
    OFS$ENRI = OFS$ENRI.ORG
    OFS$ROUTINE.ARGS = OFS$ROUTINE.ARGS.ORG
    OFS$TXN.COMPLETE = OFS$TXN.COMPLETE.ORG
    OFS$SUPRESS.TXN.COMPLETE = OFS$SUPRESS.TXN.COMPLETE.ORG
    OFS$BROWSER.MESSAGES = OFS$BROWSER.MESSAGES.ORG
    OFS$ACTIVE.MSG.REF = OFS$ACTIVE.MSG.REF.ORG
    OFS$GETTING.ID = OFS$GETTING.ID.ORG
    OFS$DEAL.SLIP.PRINTING = OFS$DEAL.SLIP.PRINTING.ORG
    OFS$CLEAR.INPUT.FIELD = OFS$CLEAR.INPUT.FIELD.ORG
    OFS$HOT.FIELD = OFS$HOT.FIELD.ORG
    OFS$QUEUE.REC = OFS$QUEUE.REC.ORG
    OFS$EB.ATTRIBUTES.CACHE = OFS$EB.ATTRIBUTES.CACHE.ORG
    OFS$REGISTER.CONTRACT.ERRORS = OFS$REGISTER.CONTRACT.ERRORS.ORG
    OFS$EXPANSION.FOCUS = OFS$EXPANSION.FOCUS.ORG
    OFS$BROWSER.HOLD = OFS$BROWSER.HOLD.ORG
    OFS$CLIENT.PRINT = OFS$CLIENT.PRINT.ORG
    OFS$PRINTER.LOCATION = OFS$PRINTER.LOCATION.ORG
    OFS$STYLE.SHEET = OFS$STYLE.SHEET.ORG
    OFS$MESSAGE = OFS$MESSAGE.ORG       ;* GLOBUS_GB_100009416
    OFS$SATUS = OFS$STATUS.ORG          ;* GLOBUS_BG_100010080 S
    OFS$PASSBOOK.DETAILS = OFS$PASSBOOK.DETAILS.ORG
    OFS$PASSBOOK.PRINT.PROMPTS = OFS$PASSBOOK.PRINT.PROMPTS.ORG
    OFS$PASSBOOK.PRINT.STAGE = OFS$PASSBOOK.PRINT.STAGE.ORG
    OFS$PASSBOOK.CONTEXT = OFS$PASSBOOK.CONTEXT.ORG         ;* GLOBUS_BG_100010080 E
    OFS$BROWSER = OFS$BROWSER.ORG       ;* Restore OFS$BROWSER variable
    OFS$VERSION.FLD = OFS$VERSION.FLD.ORG         ;* Restore OFS$VERSION variable
*
** Restore template common
*
    C_PROPERTIES = TEMP$C_PROPERTIES
    C_METHODS = TEMP$C_METHODS
    C_INPUTS = TEMP$C_INPUTS
    C_NOINPUTS = TEMP$C_NOINPUTS
    MAT C_ROUTINES = MAT TEMP$C_ROUTINES
    MAT C_ACTIONS = MAT TEMP$C_ACTIONS

RETURN
*
*-----------------------------------------------------------------------------
LOAD.DEFAULT.OFS.SOURCE:
*
** A default OFS.SOURCE record will be created in memory. This will avoid the
** need to release and create many OFS.SOURCE records
** Hard coded options are NO logging, field level validation
** Syntax will be OFS by default but if the default record type is supplied as XML
** it will be set to this
** Same Authoriser = "Yes"
*
    OFS$SOURCE.REC<OFS.SRC.DESCRIPTION> = "Default OFS record"
    OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> = "GLOBUS"
    OFS$SOURCE.REC<OFS.SRC.MAX.CONNECTIONS> = 10
    IF C$USE.T24.LOG THEN     ;* If T24 level logging is enabled
        OFS$SOURCE.REC<OFS.SRC.LOG.FILE.DIR> = "OFSLOG"     ;* set log file directory name
    END ELSE        ;* else, TAFC logging enabled
        OFS$SOURCE.REC<OFS.SRC.LOG.FILE.DIR> = "" ;* LOG.FILE.DIR is not being used, content can be removed since TAFC geenric logging is used.
    END
    OFS$SOURCE.REC<OFS.SRC.LOG.DETAIL.LEVEL> = "NONE"
    OFS$SOURCE.REC<OFS.SRC.IN.QUEUE.DIR> = "OFSIN"
    OFS$SOURCE.REC<OFS.SRC.FIELD.VAL> = "YES"
    OFS$SOURCE.REC<OFS.SRC.SAME.AUTHORISER> = "YES"
    BEGIN CASE
        CASE DEFAULT.RECORD.TYPE EQ "XML"
            OFS$SOURCE.REC<OFS.SRC.SYNTAX.TYPE> = "XML"
        CASE DEFAULT.RECORD.TYPE EQ "OFS"
            OFS$SOURCE.REC<OFS.SRC.SYNTAX.TYPE> = "OFS"
        CASE 1
            OFS$SOURCE.REC<OFS.SRC.SYNTAX.TYPE> = "OFS"
    END CASE
*
RETURN
*
*-----------------------------------------------------------------------------
*
END
