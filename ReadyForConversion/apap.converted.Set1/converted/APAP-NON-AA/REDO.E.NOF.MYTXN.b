SUBROUTINE REDO.E.NOF.MYTXN(Y.FINAL.ARRAY)
*---------------------------------------------------------------------------------
* This is a no file enquiry will fetch the details from the core routine E.STMT.ENQ.BY.CONCAT
* based on the given selection criteria
*---------------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : Sakthi Sellappillai
* Program Name   : REDO.E.NOF.MYTXN
* ODR NUMBER     : ODR-2010-08-0031
* LINKED WITH    : NOFILE.STMT.MY.TXN STNADARD.SELECTION of STMT.ENT.BOOK.MY.TXN
*---------------------------------------------------------------------------------
*IN = N/A
*OUT = Y.FINAL.ARRAY
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.10.2010     Sakthi Sellappillai   ODR-2010-08-0031        INITIAL CREATION
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
    GOSUB INITIALISE
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INITIALISE:
*---------------------------------------------------------------------------------
    Y.ID.LIST = ''
    Y.VAR.LIST = ''
    Y.FINAL.ARRAY = ''
    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    Y.STMT.ENT.ERR = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
RETURN
*---------------------------------------------------------------------------------
OPENFILE:
*---------------------------------------------------------------------------------
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    Y.ENQ.SEL.VAL = ENQ.SELECTION
    Y.ENQ.APPLN.NAME = Y.ENQ.SEL.VAL<1,1>
    CALL E.STMT.ENQ.BY.CONCAT(Y.ID.LIST)
    Y.VAR.LIST = Y.ID.LIST
    Y.CORE.LIST.VAL = Y.VAR.LIST
    Y.FINAL.COUNT.VAL = DCOUNT(Y.CORE.LIST.VAL,@FM)
    Y.INIT.COUNT = 1
    LOOP
        REMOVE Y.SEL.LIST.VAL FROM Y.CORE.LIST.VAL SETTING Y.SEL.CNT.POS
    WHILE Y.INIT.COUNT LE Y.FINAL.COUNT.VAL
        Y.SEL.SE.ID = FIELD(Y.SEL.LIST.VAL,'*',2,1)
        Y.INIT.COUNT += 1
        Y.AMOUNT.VAL = Y.SEL.LIST.VAL['*',6,1]
        IF Y.ENQ.APPLN.NAME EQ 'AI.REDO.STMT.ENT.CREDIT.TRANS' AND Y.AMOUNT.VAL GT 0 THEN
            Y.FINAL.ARRAY<-1>=Y.SEL.LIST.VAL
        END
        IF Y.ENQ.APPLN.NAME EQ 'AI.REDO.STMT.ENT.DEBIT.TRANS' AND Y.AMOUNT.VAL LT 0 THEN
            Y.FINAL.ARRAY<-1>=Y.SEL.LIST.VAL
        END
        IF  Y.ENQ.APPLN.NAME EQ 'AI.REDO.STMT.ENT.TRANS.LIST' THEN
            Y.FINAL.ARRAY<-1>=Y.SEL.LIST.VAL
        END
    REPEAT
RETURN
END
*------------------------------*END OF SUBROUTINE*--------------------------------
