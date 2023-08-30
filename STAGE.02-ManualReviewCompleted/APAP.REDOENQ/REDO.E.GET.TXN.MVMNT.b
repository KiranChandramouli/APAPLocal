$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.TXN.MVMNT(Y.FINAL.ARRAY)
*---------------------------------------------------------------------------------
* This is aenquiry for list the details of credit card
*this enquiry will fetch the data from sunnel interface
*---------------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : krishna Murthy T.S
* Program Name   : REDO.E.GET.TXN.MVMNT
* ODR NUMBER     : SUNNEL-CR
* LINKED WITH    : ENQUIRY-REDO.CCARD.TXN.MVMNT
*---------------------------------------------------------------------------------
*IN = N/A
*OUT = Y.FINAL.ARRAY
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE              ODR                   DEVELOPER                    VERSION
*--------          ----------------      --------------------      ----------------
* 15.Dec.2010     SUNNEL                 Krishna Murthy T.S        Initial creation
* 07.04.2011      PACS00036498           Prabhu N                  Date format modified
* 21-04-2011       PACS00032454           GANESH H                  MODIFICATION
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM , SM to @SM , ! to * and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INITIALISE:
*---------------------------------------------------------------------------------

    LOCATE 'CURRENCY' IN  D.FIELDS SETTING Y.CUR.POS THEN
        Y.CUR.VAL=D.RANGE.AND.VALUE<Y.CUR.POS>
    END
    IF Y.CUR.VAL EQ 'DOP' THEN
        D.RANGE.AND.VALUE<Y.CUR.POS>=1
    END
    ELSE
        D.RANGE.AND.VALUE<Y.CUR.POS>=2
    END
*PACS00032454-S
    CUR.START.DATE = D.RANGE.AND.VALUE<1>

    CUR.END.DATE=    D.RANGE.AND.VALUE<2>
*PACS00032454-E

    Y.ARRAY='BE_K_TC.BE_P_CON_MOVIMIENTOSTC_A'
    CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    Y.MSG.DESC=Y.ARRAY<8>
    Y.ALL.DATA=Y.ARRAY<6>
    IF Y.ARRAY<7> NE '0' THEN
        Y.FINAL.ARRAY=Y.MSG.DESC
        RETURN
    END
    Y.CUR=Y.ARRAY<4>
    Y.ROWS=DCOUNT(Y.ALL.DATA,@VM)
    CHANGE @VM TO @FM IN Y.ALL.DATA
    CHANGE @SM TO @VM IN Y.ALL.DATA
    Y.BAL=Y.ARRAY<5>
    Y.CNT=1
    LOOP
        Y.BAL=Y.BAL-Y.ALL.DATA<Y.CNT,6>+Y.ALL.DATA<Y.CNT,5>
        REMOVE Y.DATA FROM Y.ALL.DATA SETTING Y.DATA.POS
        Y.MSG.DESC=''
    WHILE Y.CNT LE Y.ROWS
        Y.DATE.DATA=''
        Y.DATE.DATA=Y.ALL.DATA<Y.CNT,1>
        Y.ALL.DATA<Y.CNT,1>=Y.DATE.DATA[1,4] : Y.DATE.DATA[6,2] : Y.DATE.DATA[9,2]
        Y.DATE.DATA=''
        Y.DATE.DATA=Y.ALL.DATA<Y.CNT,7>

*!PACS00032454-S

        CHANGE '-' TO '' IN Y.DATE.DATA
        Y.DATE.DATA = TRIM(Y.DATE.DATA)
        IF Y.DATE.DATA GE CUR.START.DATE AND Y.DATE.DATA LE CUR.END.DATE THEN
*!PACS00032454-E
*Y.ALL.DATA<Y.CNT,7>=Y.DATE.DATA[1,4] : Y.DATE.DATA[6,2] : Y.DATE.DATA[9,2]
            Y.ALL.DATA<Y.CNT,7>=Y.DATE.DATA
            Y.FINAL.ARRAY<-1> = Y.MSG.DESC:'*':Y.ALL.DATA<Y.CNT,1>:'*':Y.ALL.DATA<Y.CNT,7>:'*':Y.ALL.DATA<Y.CNT,2>:'*':Y.ALL.DATA<Y.CNT,3>:'*':Y.CUR:'*':Y.ALL.DATA<Y.CNT,6>:'*':Y.ALL.DATA<Y.CNT,5>:'*':Y.BAL

        END
        Y.CNT += 1
    REPEAT

    IF NOT(Y.FINAL.ARRAY) THEN
        ENQ.ERROR="No Transactions available for this Period"
    END
RETURN
END
