* @ValidationCode : MjotNDEzNDI4NTY4OkNwMTI1MjoxNjk4MzA5MDkwNDg5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Oct 2023 14:01:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
*-----------------------------------------------------------------------------
* <Rating>3640</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE T24.FS.INTERFACE(OFS.ACTION)
* Subroutine invoked from T24.FUND.SERVICES template.
* If the ACCOUNTING.STYLE is ATOMIC, then this routine will also be invoked
* from BEFORE.AUTH.WRITE in T24.FUND.SERVICES template, to validate all the
* transactions are ok. Else, ETEXT is set.
* This routine would call T24.FS.INTERFACES.xx where xx is the module in which
* the transaction needs to be created (like FT, DC or TT) or as defined in
* TFS.PARAMETER.
*
*-------------------------------------------------------------------------
*
* Modification History:
*
* 09/22/04    -   Sathish PS
*                 New Development
*
* 10/30/04    -   Sathish PS
*                 Changes made to handle History Reversal for FT, as long
*                 as HIS.REVERSAL is enabled in FT.TXN.TYPE.CONDITION &
*                 defined in TFS.PARAMETER
*
* 07/15/05    -   GP
*                 Re-initialise DC.REQD flag inside loop for each multi-value
*                 We were creating the DC records when TT is reqd
*
* 05 JAN 06   -   Sathish PS
*                 Use SAME.AUTHORISER functionality in OFS.SOURCE to overcome the
*                 issues with DC that it does not get authorised even when process
*                 ed using a zero auth version, when ACCOUNT.PARAMETER>DC.BALANCED
*                 field is set to YES or LOCK.
* 08 Feb 06   -   GP
*                 Check for DC.REQD flag as well to make sure authorisation is done for
*                  REV HOLD txns when SAME.AUTH functionality is to be used
*
* 20 Mar 06  -   GP
*                Changed the DC same authoriser logic as it was raising VAL.ERROR on TFS template
*                Make sure STMTids are fetched for both legs. Update R.UNDERLYING as full TXN.ID not as
*                individual legs (2 Legs come for same line)
*
* 26 SEP 07  -   Sathish PS
*                If EXPOSURE.METHOD in TFS.PARAMETER is set to LOCK, create AC.LOCKED.EVENTS
*                after doing TELLER.
*
* Mar 17 2008 - Code amended to take of MULTIBOOK implementations.
*
* 30 Apr 2008 - Code corrected since amount that was stored in AC.LOCKED.EVENTS was getting stored in
*             - FCY equivalent. Changed to store in LCY equivalent.
*
* 06/06/08 - Geetha Balaji
*            CHNG060608 - Fix done to calculate the correct EXP.AMT.
*            AC.LOCKED.EVENTS was being raised for the total Net entry amount.
*            Its been changed to be raised for the EXP.AMT since that in itself is in LCY.
*
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion          GLOBUS.BP File Removed, USPLATFORM.BP File Removed
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INCLUDE I_T24.FS.COMMON ;*R22 Manual Conversion

    $INSERT I_F.COMPANY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.DATA.CAPTURE
    $INSERT I_F.DC.BATCH.CONTROL

    $INCLUDE I_F.TFS.PARAMETER ;*R22 Manual Conversion  - START
    $INCLUDE I_F.TFS.TRANSACTION
    $INCLUDE I_F.T24.FUND.SERVICES

    $INCLUDE I_F.ACCOUNT.PARAMETER      ;* 05 JAN 06 - Sathish PS s/e
    $INCLUDE I_F.OFS.SOURCE   ;* 05 JAN 06 - Sathish PS s/e ;*R22 Manual Conversion  - END

    SAVE.FUNCTION = V$FUNCTION
    IF V$FUNCTION EQ 'C' THEN
        V$FUNCTION = 'I'
    END

    GOSUB INIT.OPEN.FILES
    GOSUB PRELIM.CONDS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

    IF END.ERROR THEN
        UL.OVERRIDES = ''
        COMI = ''
    END

    OFS.ACTION = UL.OVERRIDES ;* Will be used by BEFORE.UNAU.WRITE to raise Overrides
    V$FUNCTION = SAVE.FUNCTION

RETURN
*-------------------------------------------------------------------------
INIT.OPEN.FILES:

    PROCESS.GOAHEAD = 1
    INTERFACE.PGM = 'T24.FS.INTERFACE'
    WE.ARE.VALIDATING = OFS.ACTION NE 'PROCESS' OR JOURNAL.BYPASS
    TFS.TXNS = R.NEW(TFS.TRANSACTION)
    OFSS.ID = TFS$OFS.SOURCE
    TFS.AUTH.NO = TFS$AUTH.NO

    IF OFS.ACTION NE 'PROCESS' OR NOT(TFS.AUTH.NO) THEN
        TFS.AUTH.NO = ''      ;* Let whats defined in VERSION be applied
    END

    DC.REQD = 0
    FN.DC.BC = 'F.DC.BATCH.CONTROL' ; F.DC.BC = ''
    FN.SE = 'F.STMT.ENTRY' ; F.SE = ''
    FN.CE = 'F.CATEG.ENTRY' ; F.CE = ''
    FN.COMP = 'F.COMPANY' ; F.COMP = ''
    FN.TFS = 'F.T24.FUND.SERVICES' ; F.TFS = '' ; CALL OPF(FN.TFS,F.TFS)
    FN.TFS.NAU = FN.TFS :'$NAU' ; F.TFS.NAU = '' ; CALL OPF(FN.TFS.NAU,F.TFS.NAU)
    FN.FT.TXN = 'F.FT.TXN.TYPE.CONDITION' ; F.FT.TXN = ''

    DEFAULT.DC.DEPT.POS = '1,4'
    DEFAULT.DC.BATCH.POS = '5,3'
    UL.OVERRIDES = ''
    TFS.DISP.TEXT = ''
* 2O Mar 06    -GP

    DC.COND1 = (R.ACCOUNT.PARAMETER<AC.PAR.DC.BALANCED> NE '')
    DC.COND2 = (TFS$R.TFS.PAR<TFS.PAR.ALLOW.DC.ZERO.AUT> EQ 'YES')
*
    R.OFSS = '' ; ERR.OFSS = ''
    FN.OFS.SOURCE = 'F.OFS.SOURCE'
    CALL CACHE.READ('F.OFS.SOURCE',OFSS.ID,R.OFSS,ERR.OFSS)
*
    OFSS.ID<4> = 1  ;* 20100624 umar
    DC.COND3 = (R.OFSS<OFS.SRC.SAME.AUTHORISER> EQ 'YES')

    DC.COND4 = (TFS$AUTH.NO EQ 0)
    DC.OFS.SAME.AUTH = DC.COND1 AND DC.COND2 AND DC.COND3 AND DC.COND4          ;*20 Mar 06  -GP

RETURN
*-------------------------------------------------------------------------
PRELIM.CONDS:


RETURN
*-------------------------------------------------------------------------
PROCESS:
********

    NO.OF.TFS.TXNS = DCOUNT(TFS.TXNS,@VM)
    FOR MV.NO = 1 TO NO.OF.TFS.TXNS
        DC.REQD = 0 ;*GP 07/15/05 S/E
        TFS.TXN = R.NEW(TFS.TRANSACTION)<1,MV.NO>
        UNDERLYING = R.NEW(TFS.UNDERLYING)<1,MV.NO>
        REVERSAL.MARK = R.NEW(TFS.REVERSAL.MARK)<1,MV.NO>
        R.UNDERLYING = R.NEW(TFS.R.UNDERLYING)<1,MV.NO>
        IF R.UNDERLYING AND R.NEW(TFS.R.UL.STATUS)<1,MV.NO> NE 'AUT' AND V$FUNCTION EQ 'A' THEN
            REVERSAL.MARK = 'R'
            R.NEW(TFS.REVERSAL.MARK)<1,MV.NO> = REVERSAL.MARK         ;* Set it temporarily.
        END
        UL.STATUS = R.NEW(TFS.UL.STATUS)<1,MV.NO>
        R.UL.STATUS = R.NEW(TFS.R.UL.STATUS)<1,MV.NO>
        PREV.VAL.ERROR = R.NEW(TFS.VAL.ERROR)<1,MV.NO>
        RETRY = R.NEW(TFS.RETRY)<1,MV.NO> NE ''

* PACS00269508 - S
        IF V$FUNCTION EQ 'I' AND UNDERLYING  AND UL.STATUS EQ 'INAU' AND R.NEW(TFS.RECORD.STATUS) EQ 'INAO' THEN
            ETEXT = "EB-TFS.INAO.AMMEND"
            AF = TFS.RECORD.STATUS
            CALL STORE.END.ERROR
            RETURN
        END
* PACS00269508 - E


        IF TFS.TXN # '' THEN
            PRCS.COND.1 = (NOT(UNDERLYING) OR (UNDERLYING # '' AND REVERSAL.MARK # '')) AND NOT(PREV.VAL.ERROR)
            PRCS.COND.2 = (UNDERLYING # '' AND UL.STATUS NE 'AUT')
            PRCS.COND.3 = (NOT(R.UNDERLYING) AND REVERSAL.MARK) OR (R.UNDERLYING # '' AND R.UL.STATUS NE 'AUT' AND REVERSAL.MARK)
            PRCS.COND.4 = PREV.VAL.ERROR # '' AND RETRY
            PROCESS.THIS.TXN = PRCS.COND.1 + PRCS.COND.2 + PRCS.COND.3 + PRCS.COND.4
            IF PROCESS.THIS.TXN THEN
                GOSUB PROCESS.THIS.TXN
                GOSUB CHECK.AND.UPDATE.JOURNAL
            END
        END

    NEXT MV.NO

RETURN
*-------------------------------------------------------------------------
PROCESS.THIS.TXN:
    R.NEW(TFS.VAL.ERROR)<1,MV.NO> = ''
    OFS.BODY = '' ; TFS.TXN.ID = '' ; DC.LEGS = ''
    UL.COMPANY.ID = ID.COMPANY

    BEGIN CASE
        CASE TFS$R.TFS.TXN(MV.NO)<TFS.TXN.INTERFACE.TO> EQ 'FT'
            GOSUB PRELIM.CONDS.FOR.FT

        CASE TFS$R.TFS.TXN(MV.NO)<TFS.TXN.INTERFACE.TO> EQ 'TT'
            GOSUB PRELIM.CONDS.FOR.TT

        CASE TFS$R.TFS.TXN(MV.NO)<TFS.TXN.INTERFACE.TO> EQ 'DC'
            GOSUB PRELIM.CONDS.FOR.DC

    END CASE
    IF PROCESS.GOAHEAD THEN
        GOSUB SETUP.OFS       ;* Setup OFS Function & Application
        IF TFS.FUNCTION THEN
            IF TFS.FUNCTION EQ 'I' THEN
                IF NOT(MODULE.INTERFACE.PGM) THEN MODULE.INTERFACE.PGM = INTERFACE.PGM :'.': INTERFACE.MODULE
                CALL @MODULE.INTERFACE.PGM(MV.NO,OFS.BODY)  ;* Form OFS Body
                MODULE.INTERFACE.PGM = ''
                ! 26 SEP 07 - Sathish PS /s
                IF TFS$R.TFS.PAR<TFS.PAR.EXPOSURE.METHOD> EQ 'LOCK' THEN
                    IF R.NEW(TFS.EXP.SCHEDULE)<1,MV.NO> NE '' THEN
                        GOSUB BUILD.AC.LOCKED.EVENT.MESSAGES
                    END
                END
                ! 26 SEP 07 - Sathish PS /e
            END
            GOSUB CALL.OFS
        END
    END

RETURN
*--------------------------------------------------------------------------
PRELIM.CONDS.FOR.FT:

    INTERFACE.APPL = 'FUNDS.TRANSFER' ; INTERFACE.MODULE = 'FT'
    NO.HIS = 0
    RECORD.STATUS.FLD = FT.RECORD.STATUS ; STMT.NOS.FLD = FT.STMT.NOS
    OVERRIDE.FLD = FT.OVERRIDE ; CHARGE.FLD = FT.TOTAL.CHARGE.AMOUNT

RETURN
*--------------------------------------------------------------------------
PRELIM.CONDS.FOR.TT:

    INTERFACE.APPL = 'TELLER' ; INTERFACE.MODULE = 'TT'
    NO.HIS = 0
    RECORD.STATUS.FLD = TT.TE.RECORD.STATUS ; STMT.NOS.FLD = TT.TE.STMT.NO
    OVERRIDE.FLD = TT.TE.OVERRIDE
    IF R.NEW(TFS.CURRENCY)<1,MV.NO> EQ LCCY THEN
        CHARGE.FLD = TT.TE.CHRG.AMT.LOCAL
    END ELSE
        CHARGE.FLD = TT.TE.CHRG.AMT.FCCY
    END

RETURN
*--------------------------------------------------------------------------
PRELIM.CONDS.FOR.DC:

    INTERFACE.APPL = 'DATA.CAPTURE' ; INTERFACE.MODULE = 'DC'
    NO.HIS = 1
    RECORD.STATUS.FLD = DC.DC.RECORD.STATUS ; STMT.NOS.FLD = DC.DC.STMT.NO
    OVERRIDE.FLD = DC.DC.OVERRIDE
    CHARGE.FLD = ''

RETURN
*--------------------------------------------------------------------------
SETUP.OFS:

    TFS.FUNCTION = ''
    TFS.GTS.CONTROL = 1
    ALE.OFS.MSGS = ''         ;* 26 SEP 07 - Sathish PS s/e
    LOCK.REF = ''   ;* 26 SEP 07 - Sathish PS s/e

    BEGIN CASE
        CASE NOT(UNDERLYING) AND V$FUNCTION EQ 'I'
            TFS.FUNCTION = 'I'
            TFS.DISP.TEXT = 'INPUT'

        CASE UNDERLYING AND UL.STATUS[2,2] EQ 'NA' AND V$FUNCTION EQ 'A'
            TFS.FUNCTION = 'A'
            TFS.TXN.ID = UNDERLYING
            TFS.DISP.TEXT = 'AUTHORISE'

        CASE UNDERLYING AND UL.STATUS[2,2] EQ 'NA' AND REVERSAL.MARK
            TFS.FUNCTION = 'D'
            TFS.TXN.ID = UNDERLYING
            TFS.DISP.TEXT = 'DELETE'

        CASE R.UNDERLYING AND R.UL.STATUS[2,2] EQ 'NA' AND V$FUNCTION EQ 'A'
            TFS.FUNCTION = 'A'
            TFS.TXN.ID = R.UNDERLYING
            IF INTERFACE.MODULE NE 'DC' THEN
                FN.UL.FILE = 'F.':INTERFACE.APPL ; F.UL.FILE = ''
                CALL F.READ(FN.UL.FILE,UNDERLYING,R.UL.FILE,F.UL.FILE,ERR.UL.FILE)
                IF NOT(R.UL.FILE) THEN
                    DC.REQD = 1 ; ERR.UL.FILE =''     ;* 17 Mar 06  GP
                END
            END ELSE
                DC.REQD = 1
            END
            TFS.DISP.TEXT = 'REVERSE'

        CASE R.UNDERLYING AND R.UL.STATUS[2,2] EQ 'NA' AND REVERSAL.MARK
            TFS.FUNCTION = 'D'
            TFS.TXN.ID = R.UNDERLYING
            IF INTERFACE.MODULE NE 'DC' THEN
                FN.UL.FILE = 'F.':INTERFACE.APPL ; F.UL.FILE = ''
                CALL F.READ(FN.UL.FILE,UNDERLYING,R.UL.FILE,F.UL.FILE,ERR.UL.FILE)
                IF NOT(R.UL.FILE) THEN DC.REQD = 1
            END ELSE
                DC.REQD = 1
            END
            TFS.DISP.TEXT = 'UNDO REVERSE'

        CASE UNDERLYING AND UL.STATUS EQ 'AUT' AND REVERSAL.MARK
            DC.REQD = 0
            IF INTERFACE.MODULE NE 'DC' THEN
                FN.UL.FILE = 'F.':INTERFACE.APPL ; F.UL.FILE = ''
                CALL F.READ(FN.UL.FILE,UNDERLYING,R.UL.FILE,F.UL.FILE,ERR.UL.FILE)
                IF R.UL.FILE THEN
                    TFS.FUNCTION = 'R'
                    TFS.TXN.ID = UNDERLYING
                END ELSE
* 10/30/03 - Sathish PS /s
* Changes made to handle History Reversal in FT
                    DC.REQD = 1
                    IF TFS$R.TFS.TXN(MV.NO)<TFS.TXN.INTERFACE.TO> EQ 'FT' THEN
                        GOSUB CHECK.SUPPORT.FOR.FT.HIS.REVERSAL ;* check HIS.REVERSAL in FT.TXN.TYPE.CONDITION & ALLOW.FT.HIS.REV in TFS.PARAMETER
                    END
* 10/30/03 - Sathish PS /e
                END
            END ELSE
                TFS.FUNCTION = 'I'
                DC.REQD = 1
            END
            IF DC.REQD THEN
                TFS.FUNCTION = 'I'
            END
            TFS.DISP.TEXT = 'REVERSE '

    END CASE

    IF DC.REQD THEN
        GOSUB PRELIM.CONDS.FOR.DC       ;* Change the INTERFACE.APPL & INTERFACE.MODULE
    END

    IF INTERFACE.MODULE EQ 'DC' THEN
        IF TFS.FUNCTION MATCHES 'A' :@VM: 'D' THEN
            TFS.TXN.ID = TFS.TXN.ID['-',1,1] :' ALL'
        END
    END

    IF TFS.DISP.TEXT THEN TFS.DISP.TEXT := ' ':TFS.TXN.ID

    GOSUB BUILD.OFS.HEADER

RETURN
*---------------------------------------------------------------------------
* 10/30/03 - Sathish PS /s
CHECK.SUPPORT.FOR.FT.HIS.REVERSAL:

    IF TFS$R.TFS.PAR<TFS.PAR.ALLOW.FT.HIS.REV> EQ 'YES' THEN          ;* And allowed by Parameter
        FT.TXN.ID = TFS$R.TFS.TXN(MV.NO)<TFS.TXN.INTERFACE.AS>
        FT.TXN.FIELD = 'HIS.REVERSAL'
*
        CALL EB.FIND.FIELD.NO('FT.TXN.TYPE.CONDITION',FT.TXN.FIELD)
        IF NUM(FT.TXN.FIELD) THEN
            CALL F.READV(FN.FT.TXN,FT.TXN.ID,HIS.REVERSAL,FT.TXN.FIELD,F.FT.TXN,ERR.FT.TXN)
            IF HIS.REVERSAL EQ 'YES' THEN
                FN.TEMP.FILE = FN.UL.FILE:'$HIS' ; F.TEMP.FILE = '' ; CALL OPF(FN.TEMP.FILE,F.TEMP.FILE)
                TEMP.ID = UNDERLYING
                CALL F.READ.HISTORY(FN.TEMP.FILE,TEMP.ID,R.UL.FILE,F.TEMP.FILE,ERR.TEMP.FILE)       ;* Get the History ID
                IF TEMP.ID THEN
                    DC.REQD = 0
                    TFS.FUNCTION = 'R'
                    TFS.TXN.ID = TEMP.ID
                END
            END
        END
    END

RETURN
* 10/30/03 - Sathish PS /e
*--------------------------------------------------------------------------------
BUILD.OFS.HEADER:

    !TFS.AUTH.NO = 0 ; * Sesh V.S s/e - for testingv
    OFS.VERSION = TFS$R.TFS.TXN(MV.NO)<TFS.TXN.OFS.VERSION>
    LOCATE INTERFACE.MODULE IN TFS$R.TFS.PAR<TFS.PAR.APPLICATION,1> SETTING OUR.APPL.POS THEN
        IF NOT(OFS.VERSION) THEN
            OFS.VERSION = TFS$R.TFS.PAR<TFS.PAR.OFS.VERSION,OUR.APPL.POS>
        END
        MODULE.INTERFACE.PGM = TFS$R.TFS.PAR<TFS.PAR.APPLICATION.API,OUR.APPL.POS>
    END
*
    OFS.HEADER = INTERFACE.APPL : OFS.VERSION :'/': TFS.FUNCTION :'/': OFS.ACTION
    OFS.HEADER := '/': TFS.GTS.CONTROL :'/': TFS.AUTH.NO
    OFS.HEADER := ',//' : UL.COMPANY.ID

* 26 SEP 07 - Sathish PS /s
    ALE.OFS.HEADER = 'AC.LOCKED.EVENTS' : OFS.VERSION :'/': TFS.FUNCTION :'/': OFS.ACTION
    ALE.OFS.HEADER := '/': TFS.GTS.CONTROL :'/': TFS.AUTH.NO
    ALE.OFS.HEADER := ',//' : UL.COMPANY.ID
* 26 SEP 07 - Sathish PS /e

RETURN
*---------------------------------------------------------------------------
CALL.OFS:
    SAVE.OFS.BODY = OFS.BODY
    NO.OF.LEGS = DCOUNT(OFS.BODY,@FM)
    IF NOT(NO.OF.LEGS) THEN NO.OF.LEGS = 1
    PREV.DC.ID = ''  ; DC.OFS.SAME.AUTH.INP =''   ;* 20 Mar 06  GP s/e

    LOCK.REF = ''   ;* 26 SEP 07 - Sathish PS s/e

    FOR XX = 1 TO NO.OF.LEGS
        PROGRESS =  MV.NO:'/':NO.OF.TFS.TXNS:' - LEG ':XX:' ':TFS.TXN
        DISP.TEXT = OFS.ACTION :' ':PROGRESS:' ':TFS.DISP.TEXT
        CALL DISPLAY.MESSAGE(DISP.TEXT,6)

        OFS.BODY = SAVE.OFS.BODY<XX>

        IF TFS.FUNCTION EQ 'I' THEN
            TFS.TXN.ID = ''
            IF INTERFACE.MODULE EQ 'DC' THEN
                IF XX EQ 1 THEN
                    TFS.TXN.ID = 'NEW'
                END ELSE
                    IF NOT(WE.ARE.VALIDATING) THEN
                        IF PREV.DC.ID THEN
                            OFS.TXN.RET.ID = PREV.DC.ID
                            GOSUB PARSE.DC.ID
                            NEXT.LEG.NO = OFS.TXN.RET.ID['-',2,1] + 1
                            NEXT.LEG.NO = STR(0,3-LEN(NEXT.LEG.NO)) : NEXT.LEG.NO
                            OFS.TXN.RET.ID = OFS.TXN.RET.ID['-',1,1]  ;* OFS.TXN.RET.ID will be the DC id of the last leg
                            TFS.TXN.ID = OFS.TXN.RET.ID : NEXT.LEG.NO
                        END
                    END
                END
            END
        END

        OFSS.ID<4> = 1        ;*Sathya - Since the OFSS.ID gets changed after calls to OGM, set this value in the loop
        OFS.MSG = OFS.HEADER :',': TFS.TXN.ID :',': OFS.BODY
        CALL OFS.GLOBUS.MANAGER(OFSS.ID,OFS.MSG)
* 20100624 umar - start
        DC.RECORD = ''
        YDC.ID = '' ; YDC.ID = FIELD(OFS.MSG,"/",1)
        IF YDC.ID[1,2] EQ 'DC' THEN
            FN.DC = 'F.DATA.CAPTURE$NAU' ; F.DC = '' ; DC.ERR = ''
            CALL OPF(FN.DC,F.DC)
*        YDC.ID = '' ; YDC.ID = FIELD(OFS.MSG,"/",1)
            CALL F.READ(FN.DC,YDC.ID,R.DC.REC,F.DC,DC.ERR)
            IF R.DC.REC THEN
                DC.RECORD = '' ; DC.RECORD = LOWER(R.DC.REC)
            END
        END
* 20100624 umar - start
        CALL TFS.ANALYSE.OFS.MSG(OFS.MSG,RET.MSG,'','')
        IF DC.OFS.SAME.AUTH AND (TFS.FUNCTION MATCHES 'I':@VM:'R')  THEN DC.OFS.SAME.AUTH.INP = 1    ;* 20 Mar 06 GP s/e
        GOSUB HANDLE.OFS.RET.MSG        ;* 05 JAN 06 - Sathish PS s/e - moved code into separate GOSUB.
        DC.OFS.SAME.AUTH.INP =''        ;* 20 Mar 06 GP s/e
    NEXT XX
*
* 05 JAN 06 - Sathish PS /s
*

    IF NOT(WE.ARE.VALIDATING) THEN
* Only when PROCESS
        IF TFS$R.TFS.TXN(MV.NO)<TFS.TXN.INTERFACE.TO> EQ 'DC' OR  DC.REQD EQ '1' THEN     ;* 08 Feb 06 GP s/e
            IF DC.OFS.SAME.AUTH AND (TFS.FUNCTION MATCHES 'I':@VM:'R')  THEN     ;* 20 Mar 06  GP s/e
                LAST.DC.ID = OFS.MSG['/',1,1] ; ERR.LAST.DC = ''
                CALL CACHE.READ('F.DATA.CAPTURE$NAU',LAST.DC.ID,R.LAST.DC,ERR.LAST.DC)
* Is the DC leg in Unauthorised Status?
                JUNK.DC.ID = LAST.DC.ID ; JUNK.DC.ID[1] = '1'
                CALL CACHE.READ('F.DATA.CAPTURE$NAU',JUNK.DC.ID,R.JUNK.DC,ERR.JUNK.DC)
                IF R.LAST.DC<DC.DC.RECORD.STATUS>[2,2] EQ 'NA' THEN
* Then, Force authorisation...
                    AUTH.OFS.HEADER = OFS.HEADER
                    AUTH.OFS.HEADER['/',2,1] = 'A'

                    DC.AUTH.SAVE.OFS.TXN.RET.ID = OFS.TXN.RET.ID      ;* Save OFS.TXN.RET.ID
                    OFS.TXN.RET.ID = LAST.DC.ID ; GOSUB PARSE.DC.ID
                    TFS.TXN.ID = OFS.TXN.RET.ID['-',1,1] :' ALL'
                    OFS.TXN.RET.ID = DC.AUTH.SAVE.OFS.TXN.RET.ID      ;* Restore it
                    OFS.MSG = AUTH.OFS.HEADER :',': TFS.TXN.ID :','
                    OFSS.ID<4> = 1      ;* Umar - Flag set to maintain the cache
                    CALL OFS.GLOBUS.MANAGER(OFSS.ID,OFS.MSG)
                    CALL TFS.ANALYSE.OFS.MSG(OFS.MSG,RET.MSG,'','')
                    GOSUB HANDLE.OFS.RET.MSG
                END
            END
        END
    END
* 05 JAN 06 - Sathish PS /e

* 26 SEP 07 - Sathish PS /s
    GOSUB PROCESS.AC.LOCKED.EVENTS
* 26 SEP 07 - Sathish PS /e

RETURN
*--------------------------------------------------------------------------
* 26 SEP 07 - Sathish PS /s
PROCESS.AC.LOCKED.EVENTS:

    BEGIN CASE
        CASE ALE.OFS.MSGS NE ''
            NO.OF.ALE.OFS.MSGS = DCOUNT(ALE.OFS.MSGS,@FM)
            FOR ALE.OFS.CNT = 1 TO NO.OF.ALE.OFS.MSGS

                LOCK.REF = ''
                PROGRESS =  MV.NO:'/':NO.OF.TFS.TXNS:' - LEG ':XX:' ':TFS.TXN :' ': "AC.LOCKED.EVENT"
                DISP.TEXT = OFS.ACTION :' ':PROGRESS:' ':TFS.DISP.TEXT
                CALL DISPLAY.MESSAGE(DISP.TEXT,6)
                ALE.OFS.MSG = ALE.OFS.MSGS<ALE.OFS.CNT>
                OFSS.ID<4> = 1    ;* Umar - Flag set to maintain the cache
                CALL OFS.GLOBUS.MANAGER(OFSS.ID,ALE.OFS.MSG)
                CALL TFS.ANALYSE.OFS.MSG(ALE.OFS.MSG,RET.MSG,'','')
                IF RET.MSG THEN RET.MSG = 'AC.LOCKED.EVENTS' :'-': RET.MSG ELSE LOCK.REF = ALE.OFS.MSG['/',1,1]
                OFS.MSG = ALE.OFS.MSG ; GOSUB HANDLE.OFS.RET.MSG

            NEXT ALE.OFS.CNT

        CASE OTHERWISE
            LOCKED.REFS = R.NEW(TFS.LOCK.REF)<1,MV.NO>
            IF LOCKED.REFS THEN
                LOOP
                    REMOVE LOCKED.REF FROM LOCKED.REFS SETTING NEXT.LOCKED.REF.POS
                WHILE LOCKED.REF : NEXT.LOCKED.REF.POS DO

                    PROGRESS =  MV.NO:'/':NO.OF.TFS.TXNS:' - LEG ':XX:' ':TFS.TXN :' ': "AC.LOCKED.EVENT"
                    DISP.TEXT = OFS.ACTION :' ':PROGRESS:' ':TFS.DISP.TEXT
                    CALL DISPLAY.MESSAGE(DISP.TEXT,6)
                    ALE.OFS.MSG = ALE.OFS.HEADER :',': LOCKED.REF :','
                    OFSS.ID<4> = 1          ;* Umar - Flag set to maintain the cache
                    CALL OFS.GLOBUS.MANAGER(OFSS.ID,ALE.OFS.MSG)
                    CALL TFS.ANALYSE.OFS.MSG(ALE.OFS.MSG,RET.MSG,'','')
                    IF RET.MSG THEN RET.MSG = 'AC.LOCKED.EVENTS' :'-': RET.MSG
                    OFS.MSG = ALE.OFS.MSG ; GOSUB HANDLE.OFS.RET.MSG

                REPEAT
            END

    END CASE
RETURN
* 26 SEP 07 - Sathish PS /e
*------------------------------------------------------------------------------
* 05 JAN 06 - Sathish PS /s
HANDLE.OFS.RET.MSG:
    IF RET.MSG THEN
        IF R.NEW(TFS.ACCOUNTING.STYLE) EQ 'ATOMIC' THEN
            ETEXT = RET.MSG
            AF = TFS.VAL.ERROR ; AV = MV.NO
            CALL STORE.END.ERROR
        END         ;* Else, dont raise an error message. Let the user retry
        IF NOT(WE.ARE.VALIDATING) THEN
            R.NEW(TFS.VAL.ERROR)<1,MV.NO> = RET.MSG
        END
    END ELSE
        PREV.DC.ID = OFS.MSG['/',1,1]
        IF WE.ARE.VALIDATING THEN
            IF TFS$MESSAGE EQ 'BEFORE.UNAUTH' AND TFS.FUNCTION MATCHES 'I' :@VM: 'R' THEN
                TXN.OVERRIDES = 1       ;* Meaning, we need the Overrides
                CALL TFS.ANALYSE.OFS.MSG(OFS.MSG,'',TXN.OVERRIDES,'')
                IF TXN.OVERRIDES THEN
                    IF UL.OVERRIDES<MV.NO> THEN UL.OVERRIDES<MV.NO> := @VM: TXN.OVERRIDES ELSE UL.OVERRIDES = TXN.OVERRIDES
                END
            END
        END ELSE
            CALL TFS.ANALYSE.OFS.MSG(OFS.MSG,'','',UL.COMPANY.ID)
            GOSUB UPDATE.UL.DETAILS

        END
    END

RETURN
* 05 JAN 06 - Sathish PS /e
*--------------------------------------------------------------------------
UPDATE.UL.DETAILS:

    R.NEW(TFS.REVERSAL.MARK)<1,MV.NO> = ''

    BEGIN CASE
        CASE TFS.FUNCTION EQ 'D'
            BEGIN CASE
                CASE UNDERLYING AND UL.STATUS[2,2] EQ 'NA' AND REVERSAL.MARK
                    R.NEW(TFS.UNDERLYING)<1,MV.NO> = ''
                    R.NEW(TFS.UL.STATUS)<1,MV.NO> = ''
                    R.NEW(TFS.UL.STMT.NO)<1,MV.NO> = ''
                    R.NEW(TFS.UL.COMPANY)<1,MV.NO> = ''
                    R.NEW(TFS.VAL.ERROR)<1,MV.NO> = ''
                    R.NEW(TFS.LOCK.REF)<1,MV.NO> = ''     ;* 26 SEP 07 - Sathish PS s/e

                CASE R.UNDERLYING AND R.UL.STATUS[2,2] EQ 'NA' AND REVERSAL.MARK
                    R.NEW(TFS.R.UNDERLYING)<1,MV.NO> = ''
                    R.NEW(TFS.R.UL.STATUS)<1,MV.NO> = ''
                    R.NEW(TFS.R.UL.STMT.NO)<1,MV.NO> = ''

            END CASE

        CASE OTHERWISE
            GOSUB FETCH.R.UL.FILE

            OFS.TXN.RET.ID = SAVE.OFS.TXN.RET.ID
            IF INTERFACE.MODULE EQ 'DC' THEN
                GOSUB PARSE.DC.ID
            END

            IF R.UL.FILE THEN
                IF R.UL.FILE<STMT.NOS.FLD> THEN
                    GOSUB PARSE.STMT.NOS
                END
                IF R.UL.FILE<RECORD.STATUS.FLD> EQ '' THEN
                    R.UL.FILE<RECORD.STATUS.FLD> = 'AUT'
                END
                IF REVERSAL.MARK EQ 'R' THEN
                    R.NEW(TFS.R.UNDERLYING)<1,MV.NO> = OFS.TXN.RET.ID     ;*20 Mar 06   GP  s/e
                    R.NEW(TFS.R.UL.STATUS)<1,MV.NO> = R.UL.FILE<RECORD.STATUS.FLD>
                    IF R.NEW(TFS.R.UL.STMT.NO)<1,MV.NO> THEN
                        R.NEW(TFS.R.UL.STMT.NO)<1,MV.NO> := @SM: LOWER(UL.STMT.NOS)
                    END ELSE
                        R.NEW(TFS.R.UL.STMT.NO)<1,MV.NO> = LOWER(UL.STMT.NOS)
                    END
                END ELSE
                    R.NEW(TFS.UNDERLYING)<1,MV.NO> = OFS.TXN.RET.ID

                    R.NEW(TFS.UL.STATUS)<1,MV.NO> = R.UL.FILE<RECORD.STATUS.FLD>
                    IF R.NEW(TFS.UL.STMT.NO)<1,MV.NO> THEN
                        R.NEW(TFS.UL.STMT.NO)<1,MV.NO> := @SM: LOWER(UL.STMT.NOS)
                    END ELSE
                        VM.COUNT = DCOUNT(UL.STMT.NOS,@VM)
                        R.NEW(TFS.UL.STMT.NO)<1,MV.NO> = LOWER(UL.STMT.NOS)
                    END
                    IF CHARGE.FLD THEN UL.CHARGE = R.UL.FILE<CHARGE.FLD>
                    IF UL.CHARGE THEN
                        BEGIN CASE
                            CASE INTERFACE.MODULE EQ 'FT'
                                R.NEW(TFS.UL.CHARGE.CCY)<1,MV.NO> = UL.CHARGE[1,3]
                                UL.CHARGE[1,3] = ''
                                R.NEW(TFS.UL.CHARGE)<1,MV.NO> = UL.CHARGE
                            CASE INTERFACE.MODULE EQ 'TT'
                                R.NEW(TFS.UL.CHARGE.CCY)<1,MV.NO> = R.NEW(TFS.CHG.CCY)<1,MV.NO>
                                R.NEW(TFS.UL.CHARGE)<1,MV.NO> = UL.CHARGE
                        END CASE
                    END
                END
                R.NEW(TFS.UL.COMPANY)<1,MV.NO> = UL.COMPANY.ID
            END ELSE
                IF DC.OFS.SAME.AUTH.INP EQ  '' THEN   ;*20 Mar 06    GP  s/e
                    IF NOT(LOCK.REF) AND NOT(OFS.TXN.RET.ID[1,4] EQ 'ACLK') THEN    ;! 26 SEP 07 - Sathish PS s/e
                        R.NEW(TFS.VAL.ERROR)<1,MV.NO> = OFS.TXN.RET.ID :' - RECORD MISSING FROM FILE ': FN.UL.FILE
                    END ;! 26 SEP 07 - Sathish PS s/e
                END
            END
            ! 26 SEP 07 - Sathish PS /s
            IF LOCK.REF THEN
                R.NEW(TFS.LOCK.REF)<1,MV.NO,-1> = LOCK.REF
                LOCK.REF = ''
            END
            ! 26 SEP 07 - Sathish PS /e

    END CASE

RETURN
*--------------------------------------------------------------------------
FETCH.R.UL.FILE:

*-- 20100624 umar - start
*    CALL F.READV(FN.COMP,UL.COMPANY.ID,COMP.MNE,EB.COM.MNEMONIC,F.COMP,ERR.COMP)
    R.COMPANY.REC = ''
    CALL CACHE.READ(FN.COMP,UL.COMPANY.ID,R.COMPANY.REC,ERR.COMP)
    COMP.MNE = R.COMPANY.REC<EB.COM.MNEMONIC>
*-- 20100624 umar - end
*-- Mar 17-2008 /s
    ACCT.COMP.MNE = '' ; ACCT.COMP.MNE = COMP.MNE
    CALL GET.ACCOUNT.COMPANY(ACCT.COMP.MNE)
*-- Mar 17-2008 /e
    FN.UL.FILE = 'F':ACCT.COMP.MNE:'.':INTERFACE.APPL ; F.UL.FILE = '' ; CALL OPF(FN.UL.FILE,F.UL.FILE)       ;* Mar 17 - 2008 s/e
    FN.UL.FILE.NAU = FN.UL.FILE :'$NAU' ; F.UL.FILE.NAU = '' ; ; CALL OPF(FN.UL.FILE.NAU,F.UL.FILE.NAU)
    IF NOT(NO.HIS) THEN
        FN.UL.FILE.HIS = FN.UL.FILE :'$HIS' ; F.UL.FILE.HIS = '' ; CALL OPF(FN.UL.FILE.HIS,F.UL.FILE.HIS)
    END

    OFS.TXN.RET.ID = OFS.MSG['/',1,1]
    OFS.TXN.RET.ID = OFS.TXN.RET.ID[';',1,1]      ;* In case of FT HIS reversal, ID will be the History ID. Remove curr.no from id.
    SAVE.OFS.TXN.RET.ID = OFS.TXN.RET.ID

    BEGIN CASE
        CASE TFS.FUNCTION MATCHES 'I' :@VM: 'R' AND TFS$AUTH.NO NE 0       ;* New
            CALL F.READ(FN.UL.FILE.NAU,OFS.TXN.RET.ID,R.UL.FILE,F.UL.FILE.NAU,ERR.UL.FILE)

        CASE TFS.FUNCTION EQ 'I' AND TFS$AUTH.NO EQ 0
            CALL F.READ(FN.UL.FILE,OFS.TXN.RET.ID,R.UL.FILE,F.UL.FILE,ERR.UL.FILE)
            IF R.UL.FILE = "" THEN
                CALL F.READ(FN.UL.FILE.NAU,OFS.TXN.RET.ID,R.UL.FILE,F.UL.FILE.NAU,ERR.UL.FILE)          ;** check for INAO record.
            END

        CASE TFS.FUNCTION EQ 'R' AND TFS$AUTH.NO EQ 0
            CALL F.READ.HISTORY(FN.UL.FILE.HIS,OFS.TXN.RET.ID,R.UL.FILE,F.UL.FILE.HIS,ERR.UL.FILE)

        CASE (TFS.FUNCTION EQ 'A' AND TFS$AUTH.NO MATCHES '0' :@VM: '1') OR (TFS.FUNCTION EQ 'A' AND UL.STATUS[2,3] EQ 'NA2')
            IF REVERSAL.MARK THEN
                IF INTERFACE.MODULE EQ 'DC' THEN
                    CALL F.READ(FN.UL.FILE,OFS.TXN.RET.ID,R.UL.FILE,F.UL.FILE,ERR.UL.FILE)
                END ELSE
                    CALL F.READ.HISTORY(FN.UL.FILE.HIS,OFS.TXN.RET.ID,R.UL.FILE,F.UL.FILE.HIS,ERR.UL.FILE)
                END
            END ELSE
                CALL F.READ(FN.UL.FILE,OFS.TXN.RET.ID,R.UL.FILE,F.UL.FILE,ERR.UL.FILE)
            END

        CASE TFS.FUNCTION EQ 'A' AND TFS$AUTH.NO EQ 2 AND UL.STATUS[2,3] EQ 'NAU'
* Then, now the UL should be in NA2
            CALL F.READ(FN.UL.FILE.NAU,OFS.TXN.RET.ID,R.UL.FILE,F.UL.FILE.NAU,ERR.UL.FILE)

        CASE OTHERWISE  ;* To handle cases like NAO
            CALL F.READ(FN.UL.FILE.NAU,OFS.TXN.RET.ID,R.UL.FILE,F.UL.FILE.NAU,ERR.UL.FILE)

    END CASE
*
RETURN
*--------------------------------------------------------------------------------
BUILD.DC.ID:

    DC.BC.ID = OFS.TXN.RET.ID[' ',1,1] * 1
    CALL F.READ(FN.DC.BC,DC.BC.ID,R.DC.BC,F.DC.BC,ERR.DC.BC)
    IF R.DC.BC THEN
        DC.ITEMS = R.DC.BC<DC.BAT.ITEMS.USED>
        LAST.DC.ITEM = DCOUNT(DC.ITEMS,@VM)
        DC.ID = OFS.TXN.RET.ID : '-' : LAST.DC.ITEM
        OFS.TXN.RET.ID = DC.ID
    END

RETURN
*--------------------------------------------------------------------------
PARSE.DC.ID:

    DC.LEG.NO = OFS.TXN.RET.ID[3] + 0

    DC.DEPT.START = TFS$R.TFS.PAR<TFS.PAR.DC.DEPT.IN.DC.ID>[',',1,1]
    IF NOT(DC.DEPT.START) THEN DC.DEPT.START = DEFAULT.DC.DEPT.POS[',',1,1]
    DC.DEPT.LEN = TFS$R.TFS.PAR<TFS.PAR.DC.DEPT.IN.DC.ID>[',',2,1]
    IF NOT(DC.DEPT.LEN) THEN DC.DEPT.LEN = DEFAULT.DC.DEPT.POS[',',2,1]
    DC.DEPT = OFS.TXN.RET.ID[DC.DEPT.START,DC.DEPT.LEN]

    DC.BATCH.START = TFS$R.TFS.PAR<TFS.PAR.DC.BATCH.IN.DC.ID>[',',1,1]
    IF NOT(DC.BATCH.START) THEN DC.BATCH.START = DEFAULT.DC.BATCH.POS[',',1,1]
    DC.BATCH.LEN = TFS$R.TFS.PAR<TFS.PAR.DC.BATCH.IN.DC.ID>[',',2,1]
    IF NOT(DC.BATCH.LEN) THEN DC.BATCH.LEN = DEFAULT.DC.BATCH.POS[',',2,1]
    DC.BATCH = OFS.TXN.RET.ID[DC.BATCH.START,DC.BATCH.LEN]

    DC.STD.PART = ''
    IF DC.DEPT.START GT 1 THEN DC.STD.PART = OFS.TXN.RET.ID[1,DC.DEPT.START-1]
    OFS.TXN.RET.ID =  DC.STD.PART : DC.DEPT : DC.BATCH :'-': DC.LEG.NO

RETURN
*--------------------------------------------------------------------------
PARSE.STMT.NOS:

    SAVE.R.UL.FILE = R.UL.FILE
    UL.STMT.NOS = ''

    UL.STMT.NOS = ''
    IF (TFS.FUNCTION EQ 'A' AND INTERFACE.MODULE EQ 'DC') OR DC.OFS.SAME.AUTH  THEN       ;*20 Mar 06  GP s/e
        TEMP.OFS.TXN.RET.ID = OFS.TXN.RET.ID
        NO.OF.DC.LEGS = OFS.TXN.RET.ID['-',2,1]
        FOR DC.LOOP.CNT = 1 TO NO.OF.DC.LEGS
            OFS.TXN.RET.ID = TEMP.OFS.TXN.RET.ID['-',1,1] : STR(0,3-LEN(DC.LOOP.CNT)) : DC.LOOP.CNT
            CALL F.READ(FN.UL.FILE,OFS.TXN.RET.ID,R.UL.FILE,F.UL.FILE,ERR.UL.FILE)
            IF R.UL.FILE THEN
                TEMP.UL.STMT.NOS = R.UL.FILE<STMT.NOS.FLD>
                CALL TFS.PARSE.STMT.NOS(TEMP.UL.STMT.NOS,'','','')
                IF UL.STMT.NOS THEN UL.STMT.NOS := @VM: TEMP.UL.STMT.NOS ELSE UL.STMT.NOS = TEMP.UL.STMT.NOS
            END
        NEXT DC.LOOP.CNT
        OFS.TXN.RET.ID = TEMP.OFS.TXN.RET.ID
    END ELSE
        UL.STMT.NOS = R.UL.FILE<STMT.NOS.FLD>
        CALL TFS.PARSE.STMT.NOS(UL.STMT.NOS,'','','')
    END

    R.UL.FILE = SAVE.R.UL.FILE

RETURN
*---------------------------------------------------------------------------
! 26 SEP 07 - Sathish PS /s
BUILD.AC.LOCKED.EVENT.MESSAGES:

    ALE.OFS.MSGS = ''
    IF (R.NEW(TFS.NET.ENTRY) NE 'NO' AND R.NEW(TFS.NETTED.ENTRY)<1,MV.NO> EQ 'YES') OR (R.NEW(TFS.NET.ENTRY) EQ 'NO') THEN

        EXP.DATES = R.NEW(TFS.EXP.DATE)<1,MV.NO> ; EXP.AMTS = R.NEW(TFS.EXP.AMT)<1,MV.NO>
        FROM.DATE = R.NEW(TFS.CR.VALUE.DATE)<1,MV.NO>

* CHNG060608 - S - NET.ENTRY.LCY.AMT is not needed anymore, since EXP.AMT itself holds the amount in LCY.
*        NET.ENTRY.LCY.AMT = 0 ; NET.ENTRY.LCY.AMT = R.NEW(TFS.AMOUNT.LCY)<1,MV.NO>        ;* 30 Apr 2008 s/e
* CHNG060608 - E
        IF NOT(FROM.DATE) THEN FROM.DATE = TODAY
        EXP.DATE.CNT = 1
        LOOP
            REMOVE EXP.DATE FROM EXP.DATES SETTING NEXT.EXP.DATE.POS
            REMOVE EXP.AMT FROM EXP.AMTS SETTING NEXT.EXP.AMT.POS
        WHILE EXP.DATE : NEXT.EXP.DATE.POS DO

* 30 Apr 2008 /s
* CHNG060608 - S - Commenting the following 3 lines since its not needed anymore
*            IF NET.ENTRY.LCY.AMT THEN
*                EXP.AMT = NET.ENTRY.LCY.AMT
*            END
* CHNG060608 - E
* 30 Apr 2008 /e

            IGNORE.THIS.ALE = 0
            IF EXP.DATE GT FROM.DATE THEN
                ALE.OFS.BODY = '' ; ALE.OFS.MSG = ''
                ALE.OFS.BODY = 'ACCOUNT.NUMBER:1:1=': R.NEW(TFS.ACCOUNT.CR)<1,MV.NO> :','
                ALE.OFS.BODY := 'DESCRIPTION:1:1=': ID.NEW :','
                ALE.OFS.BODY := 'FROM.DATE:1:1=': FROM.DATE :','
                ALE.OFS.BODY := 'TO.DATE:1:1=': EXP.DATE :','
                ALE.OFS.BODY := 'LOCKED.AMOUNT:1:1=': EXP.AMT :','
                ALE.OFS.MSG = ALE.OFS.HEADER :',,': ALE.OFS.BODY
                ALE.OFS.MSGS<-1> = ALE.OFS.MSG
            END

            EXP.DATE.CNT += 1

        REPEAT

    END

RETURN
! 26 SEP 07 - Sathish PS /e
*-----------------------------------------------------------------------------
CHECK.AND.UPDATE.JOURNAL:

    IF WE.ARE.VALIDATING THEN RETURN

    BEGIN CASE
        CASE TFS$MESSAGE EQ 'AFTER.UNAUTH'
            CALL F.MATWRITE(FN.TFS.NAU,ID.NEW,MAT R.NEW,V)      ;* Only to update OFS RET Values in R.NEW
*        CALL JOURNAL.UPDATE(ID.NEW)     ;* We are good now. Flush it. - Sathya - should not be calling JU as cache is lost

        CASE TFS$MESSAGE EQ 'AFTER.AUTH'
            CALL F.MATWRITE(FN.TFS,ID.NEW,MAT R.NEW,V)          ;* Only to update OFS RET Values in R.NEW
*       CALL JOURNAL.UPDATE(ID.NEW)     ;* We are good now. Flush it. - Sathya - should not be calling JU as cache will be lost

    END CASE

RETURN
*---------------------------------------------------------------------------
END
