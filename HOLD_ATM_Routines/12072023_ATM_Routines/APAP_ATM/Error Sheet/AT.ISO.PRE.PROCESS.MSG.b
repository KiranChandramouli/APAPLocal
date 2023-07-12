SUBROUTINE AT.ISO.PRE.PROCESS.MSG(ISO.MESSAGE)
*----------------------------------------------------------------------------------------------------*
* Dev ISO 8583
* Developer: Anonymous
*
*
*22 OCT 2007    GP
*               Take field values from Right if no start posn defined
*09 MAY 2008    GP
*               Changes to paramaeterize forming mapping id
*
*Modification History
*  Date       Who             Reference       Description
* 13 Dec 2010 Balagurunathan ODR-2010-08-0469 added the logic of appending acquirer network ref for Request mapping.
*----------------------------------------------------------------------------------------------------*

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.DATES
    $INSERT I_AT.ISO.COMMON
    $INSERT I_F.INTRF.MESSAGE
    $INSERT I_F.INTRF.MAPPING
    $INSERT I_F.REDO.CARD.BIN
*----------------------------------------------------------------------------------------------------*
    GOSUB CHK.PRELIM.CONDS
    IF NOT(PROCESS.GOAHEAD) THEN
        RETURN
    END
    CALL RAD.LOG.MSG("ATM","DEBUG",ISO.MESSAGE)

    GOSUB INITIALISE

    GOSUB READ.MSG.SKELETON

    GOSUB PARSE.REQUEST

    GOSUB STORE.REQ
    GOSUB READ.MAPPING

    GOSUB FORM.OFS.REQ


    OFS.REQ.TO.LOG = ISO.MESSAGE

    CHANGE R.MAPPING<INTRF.MAP.OFS.PASSWORD> TO '*******' IN OFS.REQ.TO.LOG     ;* Mask password
    CALL RAD.LOG.MSG("ATM","DEBUG",OFS.REQ.TO.LOG)



RETURN          ;*Main
*---------------------------------------------------------------------------------------------------------------*
FORM.OFS.REQ:
*------------*

    CALL RAD.LOG.MSG("ATM","DEBUG","Mapping ID to use ":REQ.MAPPING.ID)
    OFS.OPERATION=''
*ADDED ANITHA BIAT
    ENQ.NAME =''
    IF INDEX(OFS.UTIL.NAME,"ENQUIRY.SELECT",1) THEN
        ENQ.NAME = FIELD(OFS.UTIL.NAME,",",2)
        OFS.UTIL.NAME = "ENQUIRY.SELECT"
    END
*END ANITHA BIAT

    GOSUB FORM.COMPANY.RECORD.ID
    IF NOT(INDEX(ID.GEN,'R/',1))  THEN  ;* If we are reversing don't bother forming appl fields
        GOSUB FORM.REMAINING.FIELDS
    END

    IF NOT(INDEX(OFS.UTIL.NAME,"ENQUIRY.SELECT",1)) THEN
        SEL.STRING = FIELD.REQ.STR
    END

    OFS.OPERATION=''
    IF OFS.UTIL.NAME EQ 'ENQUIRY.SELECT' THEN
        ISO.MESSAGE = OFS.UTIL.NAME:",":OFS.FUNCTION:",":SIGN.ON.DETLS:",":ENQ.NAME:",":SEL.STRING:FIELD.REQ.STR
    END ELSE

        GOSUB ID.GEN.PARA

    END

RETURN          ;*from FORM.OFS.REQ
*-------------
ID.GEN.PARA:
*--------------

    IF (UNASSIGNED(ID.GEN) OR LEN(ID.GEN) LE 2) AND PART.REV.MSG EQ '' AND NOT(INDEX(OFS.UTIL.NAME,"LATAM.CARD.ORDER",1)) THEN
        ISO.MESSAGE = OFS.UTIL.NAME:"/":OFS.FUNCTION:"/":OFS.OPERATION:",":SIGN.ON.DETLS:"/":COMPANY.ID:",":",":SEL.STRING
    END ELSE
*ID gen routine attached or special processing reqd
        GEN.ID =''
        IF INDEX(ID.GEN,'/',1) THEN
            OFS.FUNCTION = FIELD(ID.GEN,'/',1)
            GEN.ID = FIELD(ID.GEN,'/',2)
        END
        IF INDEX(OFS.UTIL.NAME,"LATAM.CARD.ORDER",1) THEN

            GEN.ID=AT$INCOMING.ISO.REQ(2)
        END
        ISO.MESSAGE = OFS.UTIL.NAME:"/":OFS.FUNCTION:"/":OFS.OPERATION:",":SIGN.ON.DETLS:"/":COMPANY.ID:",":GEN.ID:",":SEL.STRING
        IF PART.REV.MSG NE '' THEN
            OFS.FUNCTION='R'
            REV.GEN.ID=FIELD(PART.REV.MSG,'/',2)
            OFS.REV= OFS.UTIL.NAME:"/":OFS.FUNCTION:"/":OFS.OPERATION:",":SIGN.ON.DETLS:"/":COMPANY.ID:",":REV.GEN.ID
*         CALL OFS.GLOBUS.MANAGER(OFS$SOURCE.ID,OFS.REV)
            Y.theResponse=''
            Y.txnCommitted=''
            CALL OFS.CALL.BULK.MANAGER(OFS$SOURCE.ID,OFS.REV,Y.theResponse, Y.txnCommitted)

        END
    END

RETURN

*---------------------------------------------------------------------------------------------------------------*
FORM.REMAINING.FIELDS:
*---------------------*

    CNT.MAP.FLDS=DCOUNT(R.MAPPING<INTRF.MAP.INTRF.FLD.NAME>,@VM)
    FOR II = 1 TO CNT.MAP.FLDS

        BEGIN CASE

            CASE R.MAPPING<INTRF.MAP.FIELD.SOURCE,II> EQ 'ENQ.SEL'
                FLD.MSG.POSN = R.MAPPING<INTRF.MAP.INTRF.FLD.PS,II,1>
                IF FLD.MSG.POSN THEN
                    GOSUB FORM.FIELD.VALUE
                END
                SEL.STRING := R.MAPPING<INTRF.MAP.GLO.FLD.NAME,II>:":EQ= ":FLD.VALUE:','

            CASE R.MAPPING<INTRF.MAP.FIELD.SOURCE,II> EQ 'INT'

                FLD.MSG.POSN = R.MAPPING<INTRF.MAP.INTRF.FLD.PS,II,1>

                IF FLD.MSG.POSN THEN
                    GOSUB FORM.FIELD.VALUE
                END
                FIELD.REQ.STR := R.MAPPING<INTRF.MAP.GLO.FLD.NAME,II>:"=":FLD.VALUE:','

            CASE R.MAPPING<INTRF.MAP.FIELD.SOURCE,II> EQ 'CON'
                GOSUB PROCESS.T24.CONSTANTS

                FIELD.REQ.STR := R.MAPPING<INTRF.MAP.GLO.FLD.NAME,II>:"=":FLD.VALUE:','
*ADDED ANITHA BRIS 08.04.09

                IF OFS.UTIL.NAME EQ 'ENQUIRY.SELECT' THEN
                    FIELD.REQ.STR1=FIELD(FIELD.REQ.STR,'=',1)
                    FIELD.REQ.STR2=FIELD(FIELD.REQ.STR,'=',2)
                    IF FIELD.REQ.STR1 NE '' THEN
                        FIELD.REQ.STR=FIELD.REQ.STR1:":EQ= ":FIELD.REQ.STR2
                    END
                END
*ENDED ANITHA BRIS 08.04.09

            CASE R.MAPPING<INTRF.MAP.FIELD.SOURCE,II> EQ 'RTN'
                FLD.RTN = R.MAPPING<INTRF.MAP.FIELD.SRC.VALUE,II>
                FLD.MSG.POSN = R.MAPPING<INTRF.MAP.INTRF.FLD.PS,II,1>
                COMP.FLAG= ''
                CALL CHECK.ROUTINE.EXIST(FLD.RTN,COMP.FLAG,RET.INFO)
                IF FLD.MSG.POSN THEN
                    GOSUB FORM.FIELD.VALUE
                END
                IF COMP.FLAG EQ '1' THEN
                    CALL @FLD.RTN(FLD.VALUE,RET.VALUE)
                    CALL RAD.LOG.MSG("ATM","DEBUG","Calling ":FLD.RTN :" ,":FLD.VALUE:" ,":RET.VALUE)
                END ELSE
                    CALL RAD.LOG.MSG("ATM","DEBUG","Unable to call ":FLD.RTN)
                END
                FIELD.REQ.STR := R.MAPPING<INTRF.MAP.GLO.FLD.NAME,II>:"=":RET.VALUE:','
        END CASE

    NEXT II


RETURN          ;*From form remaining fields
*---------------------------------------------------------------------------------------------------------------*
PROCESS.T24.CONSTANTS:
*--------------------*

    FLD.VALUE = R.MAPPING<INTRF.MAP.GLO.CONSTANT,II>
    IF FLD.VALUE[1,1] EQ '!' THEN
        BEGIN CASE
            CASE TRIM(FLD.VALUE) EQ '!TODAY'
                FLD.VALUE = TODAY
            CASE TRIM(FLD.VALUE) EQ '!LAST.WORKING.DAY'
                FLD.VALUE = R.DATES(EB.DAT.LAST.WORKING.DAY)
            CASE TRIM(FLD.VALUE) EQ '!NEXT.WORKING.DAY'
                FLD.VALUE = R.DATES(EB.DAT.NEXT.WORKING.DAY)
            CASE TRIM(FLD.VALUE) EQ '!LCCY'
                FLD.VALUE = LCCY
            CASE TRIM(FLD.VALUE) EQ '!ID.COMPANY'
                FLD.VALUE = ID.COMPANY
        END CASE
    END

RETURN          ;*From Process T24 Constants

*---------------------------------------------------------------------------------------------------------------*
FORM.COMPANY.RECORD.ID:
*---------------------*

    COMPANY.ID =   R.MAPPING<INTRF.MAP.OFS.COM.CODE>
    IF COMPANY.ID[1,1] EQ '@' THEN
        COMP.RTN.NAME = FIELD(COMPANY.ID,':',1)
        COMP.RTN.NAME = COMP.RTN.NAME[2,LEN(COMP.RTN.NAME)] ;* remove @
        COMP.FLAG =''
        CALL CHECK.ROUTINE.EXIST(COMP.RTN.NAME,COMP.FLAG,RET.INFO)
        IF COMP.FLAG EQ '1' THEN
            CNT.COMP.ID=DCOUNT(COMPANY.ID,':')
            FOR JK = 2 TO CNT.COMP.ID
                COMP.FLD.POSN = FIELD(COMPANY.ID,':',JK)
                COMP.RTN.PARAM := FLD.VAL.ARR(COMP.FLD.POSN)

            NEXT JK
            COMPANY.ID =''
            CALL @COMP.RTN.NAME(COMP.RTN.PARAM,COMPANY.ID)
            CALL RAD.LOG.MSG("ATM","DEBUG","Calling ":COMP.RTN.NAME:" ":COMP.RTN.PARAM:" ,":COMPANY.ID)
        END ELSE
            CALL RAD.LOG.MSG("ATM","DEBUG","Unable to call ":COMP.RTN.NAME )
        END
    END
*

    ID.GEN = R.MAPPING<INTRF.MAP.ID.GEN>
    IF ID.GEN[1,1] EQ '@' THEN
        ID.RTN.NAME = FIELD(ID.GEN,':',1)
        ID.RTN.NAME = ID.RTN.NAME[2,LEN(ID.RTN.NAME)]       ;* remove @
        COMP.FLAG =''
        CALL CHECK.ROUTINE.EXIST(ID.RTN.NAME,COMP.FLAG,RET.INFO)
        IF COMP.FLAG EQ '1' THEN
            FLD.MSG.POSN = FIELD(ID.GEN,':',2)
            GOSUB FORM.FIELD.VALUE
            ID.GEN =''
            CALL @ID.RTN.NAME(FLD.VALUE,ID.GEN)
            CALL RAD.LOG.MSG("ATM","DEBUG","Calling ":ID.RTN.NAME:",":FLD.VALUE:", ":ID.GEN)
        END ELSE
            CALL RAD.LOG.MSG("ATM","DEBUG","Unable to call ":ID.RTN.NAME )
        END
    END

RETURN          ;* From FORM.COMPANY.RECORD.ID

*---------------------------------------------------------------------------------------------------------------*
INITIALISE:
*-----------*
    Y.ATM.TXN.REF = ''
    TXN.SOURCE  =''
    PART.REV.MSG=''
    DIM FLD.LEN(129)
    DIM FLD.PROP(129)
    DIM FLD.VAL.ARR(123)
    COMP.RTN.PARAM =''
    ID.RTN.PARAM =''
    AT$AT.ISO.RAW.MSG = ISO.MESSAGE
    AT$AT.ISO.RESP.CODE ='0'
*
    FN.INTRF.MAPPING = 'F.INTRF.MAPPING'
    F.INTRF.MAPPING = ''
    CALL OPF(FN.INTRF.MAPPING,F.INTRF.MAPPING)
*
    FN.REDO.CARD.BIN='F.REDO.CARD.BIN'
    F.REDO.CARD.BIN=''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    FN.INTRF.MESSAGE = 'F.INTRF.MESSAGE'
    F.INTRF.MESSAGE =''
    CALL OPF(FN.INTRF.MESSAGE,F.INTRF.MESSAGE)

RETURN          ;*From initialise
*----------------------------------------------------------------------------------------------*
STORE.REQ:
*---------*
    MATBUILD INCOMING.ISO.REQ FROM FLD.VAL.ARR
*  FOR KK =1 TO 103
*        IF NOT(FLD.VAL.ARR(KK)) THEN FLD.VAL.ARR(KK) =''
*  NEXT KK
    MAT AT$INCOMING.ISO.REQ = MAT FLD.VAL.ARR
    MAT AT$ISO.MESSAGE.SKELETON = MAT FLD.PROP
RETURN          ;*From store req
*------------------------------------------------------------------------------------------------*
READ.MSG.SKELETON:
*------------------*
    CALL CACHE.READ(FN.INTRF.MESSAGE,"5002",R.INTRF.MSG,ER.INTRF.MSG)
    FLD.RTN = R.INTRF.MSG<INTRF.MSG.INTRF.PRE.CHECK>
    FLD.VALUE = ISO.MESSAGE
    COMP.FLAG= ''
    CALL CHECK.ROUTINE.EXIST(FLD.RTN,COMP.FLAG,RET.INFO)
    IF COMP.FLAG EQ '1' THEN
        CALL @FLD.RTN(FLD.VALUE,RET.VALUE)
        CALL RAD.LOG.MSG("ATM","DEBUG","Calling ":FLD.RTN :" ,":FLD.VALUE:" ,":RET.VALUE)
        ISO.MESSAGE = RET.VALUE
        FLD.VALUE =''
    END ELSE
        CALL RAD.LOG.MSG("ATM","DEBUG","Unable to call ":FLD.RTN)
    END

    FLD.NOS = R.INTRF.MSG<INTRF.MSG.INTRF.FLD.POS>
    Y.CNT.FLD.NOS=DCOUNT(FLD.NOS,@VM)
    FOR IJ = 1 TO Y.CNT.FLD.NOS
        MSG.FLD.POSN =R.INTRF.MSG<INTRF.MSG.INTRF.FLD.POS,IJ>
        IF NUM(MSG.FLD.POSN) AND MSG.FLD.POSN NE '0' THEN
            FLD.PROP(MSG.FLD.POSN) = R.INTRF.MSG<INTRF.MSG.INTRF.FLD.LEN,IJ>:'-':R.INTRF.MSG<INTRF.MSG.INTRF.FLD.TYPE,IJ>
        END
    NEXT IJ

    MAT FLD.LEN = MAT FLD.PROP

RETURN          ;*From READ.MSG.SKELETON
*-----------------------------------------------------------------------------------------------------*
READ.MAPPING:
*-----------*
* 09 MAY 2008  GP rewrote part of this gosub to parameterize mapping id formation

*added by anitha for KCB 09 May 08 s
    FLD.RTN=R.INTRF.MSG<INTRF.MSG.MAPPING.ID><1,1>
*    IF FLD.RTN EQ '@' THEN
*       COMP.FLAG=''
*      CALL CHECK.ROUTINE.EXIST(FLD.RTN,COMP.FLAG,RET.INFO)
*     CALL @FLD.RTN
*END
*ended 9 May 08 e
* Allow hook for changing the mapping id to meet client specific requirements

    IF FLD.RTN[1,1] EQ '@' THEN         ;* a routine has been attached try calling it
        REQ.MAPPING.ID =''
        FLD.MSG.POSN = FIELD(FLD.RTN,":",2)
        FLD.RTN = FIELD(FLD.RTN,":",1)[2,99]      ;* Leave out the @ symbol
        COMP.FLAG=''
        CALL CHECK.ROUTINE.EXIST(FLD.RTN,COMP.FLAG,RET.INFO)
        GOSUB FORM.FIELD.VALUE
        IF COMP.FLAG THEN
            CALL @FLD.RTN (FLD.VALUE,REQ.MAPPING.ID)
        END
    END ELSE
        REQ.MAPPING.ID = "ISO"          ;* No routine attached normal processing
*Check debit or credit card
        MESG.TYP.IND1=MESG.TYP.IND
        GOSUB READ.CR.OR.DB

        REQ.MAPPING.ID := MESG.TYP.IND
        MESG.TYP.IND=MESG.TYP.IND1

*  Changes done for POS - anitha 08/05/08 s/e
*    IF PROCESSING.CODE THEN

        INIT.MAPID=REQ.MAPPING.ID       ;*assign initial mapping id

        IF PROCESSING.CODE NE '' THEN

            BEGIN CASE

                CASE FLD.VAL.ARR(42)[15,1] NE 'P'

* IF (FLD.VAL.ARR(32)EQ 1 OR FLD.VAL.ARR(32) EQ 3 OR FLD.VAL.ARR(32) EQ 4) THEN

                    CHNL.VAL = FLD.VAL.ARR(32) *1

*REQ.MAPPING.ID := PROCESSING.CODE:FLD.VAL.ARR(32)     ;* Form the id for the mapping file from the message

* checks id with iso+mti+pcode+32 field + 39 .


                    REQ.MAPPING.ID= INIT.MAPID:PROCESSING.CODE:CHNL.VAL :FLD.VAL.ARR(39)
                    ER.MAPPING=''
                    GOSUB READ.MAP

                    IF ER.MAPPING THEN

* checks id with iso+mti+pcode+32

                        REQ.MAPPING.ID= INIT.MAPID:PROCESSING.CODE:CHNL.VAL
                        ER.MAPPING=''
                        GOSUB READ.MAP
                    END

                    IF ER.MAPPING THEN
* checks id with iso+mti+pcode+33 field +39

                        CHNL.VAL = FLD.VAL.ARR(33) *1


                        REQ.MAPPING.ID= INIT.MAPID:PROCESSING.CODE:CHNL.VAL :FLD.VAL.ARR(39)
                        ER.MAPPING=''
                        GOSUB READ.MAP
                    END

                    IF ER.MAPPING THEN
* checks id with iso+mti+pcode+33 field
                        REQ.MAPPING.ID= INIT.MAPID:PROCESSING.CODE:CHNL.VAL
                        ER.MAPPING=''
                        GOSUB READ.MAP
                    END



                CASE OTHERWISE

                    CHNL.VAL = FLD.VAL.ARR(32) *1
                    REQ.MAPPING.ID = INIT.MAPID : PROCESSING.CODE:CHNL.VAL:'P'
                    GOSUB READ.MAP

            END CASE



        END ELSE
            REQ.MAPPING.ID = INIT.MAPID : FLD.VAL.ARR(70)   ;* For n/w msgs no processing code,take Network msg id
            GOSUB READ.MAP
        END
    END

    CALL RAD.LOG.MSG("ATM","DEBUG","REQ MAP ID:":REQ.MAPPING.ID)
    CALL RAD.LOG.MSG("ATM","DEBUG","REQ MAP RESPONSE:":ER.MAPPING)


    IF ER.MAPPING THEN
        GOSUB HANDLE.REQ.NOT.SUPP
    END

******Note::::
*here we can add to say if no INTRF mapping is match we set a default iso format and send message
************

    SIGN.ON.DETLS =R.MAPPING<INTRF.MAP.OFS.USER> :"/":R.MAPPING<INTRF.MAP.OFS.PASSWORD>

    OFS.UTIL.NAME = R.MAPPING<INTRF.MAP.OFS.UTIL.NAME>
    OFS.FUNCTION = R.MAPPING<INTRF.MAP.OFS.FUNCTION>
    OFS.OPERATION = R.MAPPING<INTRF.MAP.OFS.OPERATION>
    RES.MAP.ID = R.MAPPING<INTRF.MAP.RES.MAP.ID>
    AT$AT.REQ.MAP.ID = REQ.MAPPING.ID
    AT$AT.RES.MAP.ID =RES.MAP.ID
    FLD.VAL.ARR(1)= MESG.TYP.IND
    AT$INCOMING.ISO.REQ(1)=MESG.TYP.IND
    ISO.APPLICATION=R.MAPPING<INTRF.MAP.APPLICATION>

RETURN          ;*From read mapping

***********
READ.MAP:
***********
    ER.MAPPING=''
    CALL CACHE.READ(FN.INTRF.MAPPING,REQ.MAPPING.ID,R.MAPPING,ER.MAPPING)

RETURN

*-----------------------------
READ.CR.OR.DB:
*-----------------------------

    IF MESG.TYP.IND EQ '0420' AND (FLD.VAL.ARR(32) EQ '01' OR FLD.VAL.ARR(32) EQ '1') THEN
        Y.CRD.ID=FLD.VAL.ARR(2)[1,6]
        CALL F.READ(FN.REDO.CARD.BIN,Y.CRD.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,CRD.ERR)
        IF R.REDO.CARD.BIN AND R.REDO.CARD.BIN<REDO.CARD.BIN.BIN.TYPE> EQ 'DEBIT' THEN
            MESG.TYP.IND='0400'
        END

    END


RETURN
*---------------------------------------------------------------------------------------------------------*
FORM.FIELD.VALUE:
*----------------*
    FLD.VALUE =''
    IF INDEX(FLD.MSG.POSN,'*',1) THEN   ;* Multiple ISO Fields going to one T24 field
        JJ.CNT=DCOUNT(FLD.MSG.POSN,'*')
        FOR JJ=1 TO JJ.CNT

            GOSUB FORM.FLD.LOOP

* IF FIELD(FLD.MSG.POSN,'*',JJ)[1,1] NE 'C' THEN
*     IF INDEX(FIELD(FLD.MSG.POSN,'*',JJ),'[',1) THEN
*         THIS.FLD.MSG.POSN = FIELD(FLD.MSG.POSN,'*',JJ)
*         GOSUB HANDLE.SUBSTRING
*         FLD.VALUE :=THIS.FLD.VALUE
*     END ELSE
*         FLD.VALUE :=   FLD.VAL.ARR(FIELD(FLD.MSG.POSN,'*',JJ))
*     END
* END ELSE
*     FLD.VALUE := FIELD(FLD.MSG.POSN,'*',JJ)[2,999]
* END
        NEXT JJ
    END ELSE
        IF INDEX (FLD.MSG.POSN,'[',1) THEN        ;* Single ISO field but may contain substring operator
            THIS.FLD.MSG.POSN =FLD.MSG.POSN
            GOSUB HANDLE.SUBSTRING
            FLD.VALUE = THIS.FLD.VALUE
        END ELSE
            FLD.VALUE  = FLD.VAL.ARR(FLD.MSG.POSN)          ;* One to One field no substring,plain vanilla
        END
    END

RETURN          ;* From Form field values
*------------------
FORM.FLD.LOOP:
*-------------------
    IF FIELD(FLD.MSG.POSN,'*',JJ)[1,1] NE 'C' THEN
        IF INDEX(FIELD(FLD.MSG.POSN,'*',JJ),'[',1) THEN
            THIS.FLD.MSG.POSN = FIELD(FLD.MSG.POSN,'*',JJ)
            GOSUB HANDLE.SUBSTRING
            FLD.VALUE :=THIS.FLD.VALUE
        END ELSE
            FLD.VALUE :=   FLD.VAL.ARR(FIELD(FLD.MSG.POSN,'*',JJ))
        END
    END ELSE
        FLD.VALUE := FIELD(FLD.MSG.POSN,'*',JJ)[2,999]
    END

RETURN
*---------------------------------------------------------------------------------------------------------*
HANDLE.SUBSTRING:
*----------------*

    POSNS = FIELD (THIS.FLD.MSG.POSN,'[',2)
    THIS.FLD.MSG.POSN =FIELD (THIS.FLD.MSG.POSN,'[',1)
    START.POSN = FIELD(POSNS,',',1)
    FLD.MSG.LENGTH = FIELD(POSNS,',',2)
    FLD.MSG.LENGTH = TRIM(FLD.MSG.LENGTH,']','A')
    IF FLD.MSG.LENGTH THEN    ;*22 OCT 2007 GP S/E
        THIS.FLD.VALUE = FLD.VAL.ARR(THIS.FLD.MSG.POSN)[START.POSN,FLD.MSG.LENGTH]
    END ELSE
        START.POSN = TRIM(START.POSN,']','A')
        THIS.FLD.VALUE = FLD.VAL.ARR(THIS.FLD.MSG.POSN)[START.POSN]   ;*22 OCT 2007 GP S/E
    END

RETURN          ;* From Handle substring
*---------------------------------------------------------------------------------------------------------*
HANDLE.REQ.NOT.SUPP:
*------------------*
    CALL RAD.LOG.MSG("ATM","FATAL","Request Mapping not Found for this service!! ":REQ.MAPPING.ID)


* Processing code not supported  handled here....


RETURN          ;* From HANDLE.REQ.NOT.SUPP

*------------------------------------------------------------------------------------------------------------*
PARSE.REQUEST:
*------------*
    IF NOT(ISO.MESSAGE) THEN
        RETURN
    END
    LEN.ISO.MESSAGE = ISO.MESSAGE[1,4]
    MESG.TYP.IND = ISO.MESSAGE[5,4]
    HEX.BIT.MAP = ISO.MESSAGE[9,16]
*    IF ISO.MESSAGE[9,1] EQ 'f' OR ISO.MESSAGE[9,1] EQ 'F' THEN
    HEX.BIT.MAP = UPCASE(HEX.BIT.MAP)
    BIN.BIT.MAP = OCONV(HEX.BIT.MAP,"MCXB")
    IF BIN.BIT.MAP[1,1] EQ "1" THEN

        HEX.BIT.MAP:= ISO.MESSAGE[25,16]
        SECONDARY.BIT.MAP = 'Y'
    END ELSE
        SECONDARY.BIT.MAP =''
    END

    FIELD.VALUES = "(0)(":MESG.TYP.IND:")"

    HEX.BIT.MAP = UPCASE(HEX.BIT.MAP)
    BIN.BIT.MAP = OCONV(HEX.BIT.MAP,"MCXB")
    CHANGE ' ' TO '' IN BIN.BIT.MAP
    Y.LEN.BIN=LEN(BIN.BIT.MAP)
    FOR II =1 TO Y.LEN.BIN
        IF BIN.BIT.MAP[II,1] EQ '1' THEN
            FIELDS.PRESENT := ' ':II
            FIELDS.PRESENT.ARR<-1> =II
        END
    NEXT II

    IF SECONDARY.BIT.MAP EQ 'Y' THEN
        MSG.CONTENT.START.POSN = 41
    END ELSE
        MSG.CONTENT.START.POSN = 25
    END
    CNT = DCOUNT(FIELDS.PRESENT.ARR,@FM)

    START.POSN = MSG.CONTENT.START.POSN
*
    FOR KK =2 TO 123          ;* Leaving MTI and Bit map we'll have to parse the rest

        FIND KK IN FIELDS.PRESENT.ARR SETTING POSN ELSE
            POSN =''
        END

        IF POSN THEN
            IF INDEX(FLD.LEN(KK),'LLL',1) THEN
                LEN.OF.FIELD = ISO.MESSAGE[START.POSN,3]
                START.POSN+=3
                FIELD.VAL = ISO.MESSAGE[START.POSN,LEN.OF.FIELD]
            END ELSE
                IF INDEX(FLD.LEN(KK),'LL',1) THEN
                    LEN.OF.FIELD = ISO.MESSAGE[START.POSN,2]
                    START.POSN +=2      ;* length
                    FIELD.VAL = ISO.MESSAGE[START.POSN,LEN.OF.FIELD]
                END ELSE
                    LEN.OF.FIELD = FIELD(FLD.LEN(KK),'-',1)
                    FIELD.VAL = ISO.MESSAGE[START.POSN,LEN.OF.FIELD]
                END
            END

            IF  KK EQ 3 THEN
                PROCESSING.CODE = FIELD.VAL
            END
            START.POSN+= LEN.OF.FIELD

            IF FIELD.VAL NE '' THEN
                FIELD.VALUES := "(":KK:")":"(": FIELD.VAL :")"
                FLD.VAL.ARR(KK) = FIELD.VAL
            END ELSE
                FLD.VAL.ARR(KK) =''
            END

        END
    NEXT KK

    CALL RAD.LOG.MSG("ATM","INFO",FIELD.VALUES)

RETURN          ;*From process
*--------------------------------------------------------------------------------------------------------*
CHK.PRELIM.CONDS:
*----------------*


    PROCESS.GOAHEAD = 1
    IF NOT(ISO.MESSAGE) THEN
        PROCESS.GOAHEAD=0
    END
    IF NOT(NUM(ISO.MESSAGE[1,4])) THEN
        PROCESS.GOAHEAD =0
    END


RETURN          ;* From CHK.PRELIM.CONDS


*--------------------------------------------------------------------------------------------------------*
END
