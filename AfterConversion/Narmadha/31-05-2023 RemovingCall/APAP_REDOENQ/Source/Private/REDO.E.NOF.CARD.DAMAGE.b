$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.CARD.DAMAGE(RETURN.DATA)
*------------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program  Name     : REDO.E.NOF.CARD.DAMAGE
*-------------------------------------------------------------------------------------------------------------
*Description  : This is a no file enquiry routine for the enquiry REDO.DAMAGED.CARD.REPORT
*Linked With  : Enquiry REDO.DAMAGED.CARD.REPORT
*In Parameter : N/A
*Out Parameter: RETURN.DATA
*--------------------------------------------------------------------------------------------------------------
*Modification History:
*---------------------
*    Date            Who                  Reference               Description
*   -------         ------              -------------            --------------
*1st Oct 2010       DHAMU.S             ODR-2010-03-0125         Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , SM to @SM and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*---------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CARD.DMG.EMBOSS
    $INSERT I_F.REDO.CARD.DAMAGE.VIRGIN
    $INSERT I_F.CARD.TYPE

*---------------------------------------------------------------------------------------------------------------

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------------------------------------------
*****
INIT:
*****
    FN.CARD.TYPE ='F.CARD.TYPE'
    F.CARD.TYPE =''

    FN.REDO.CARD.DMG.EMBOSS ='F.REDO.CARD.DMG.EMBOSS'
    F.REDO.CARD.DMG.EMBOSS = ''

    FN.REDO.CARD.DAMAGE.VIRGIN ='F.REDO.CARD.DAMAGE.VIRGIN'
    F.REDO.CARD.DAMAGE.VIRGIN  = ''

RETURN
*----------------------------------------------------------------------------------------------------------------
*********
OPENFILES:
*********

    CALL OPF(FN.REDO.CARD.DAMAGE.VIRGIN,F.REDO.CARD.DAMAGE.VIRGIN)
    CALL OPF(FN.REDO.CARD.DMG.EMBOSS,F.REDO.CARD.DMG.EMBOSS)

RETURN
*-----------------------------------------------------------------------------------------------------------------
********
PROCESS:
********
    SEL.CMD ="SELECT ":FN.REDO.CARD.DMG.EMBOSS
    SEL.CMD.1 ="SELECT ":FN.REDO.CARD.DAMAGE.VIRGIN

    LOCATE "CARD.TYPE" IN D.FIELDS<1> SETTING Y.CARD.TYPE.POS THEN
        Y.CARD.TYPE = D.RANGE.AND.VALUE<Y.CARD.TYPE.POS>
        SEL.CMD:=" WITH OLD.CARD.TYPE EQ ": Y.CARD.TYPE
        SEL.CMD.1:=" WITH CARD.TYPE EQ ": Y.CARD.TYPE
    END ELSE
        Y.CARD.TYPE = ""
        SEL.CMD:=" WITH OLD.CARD.TYPE NE '' "
        SEL.CMD.1:=" WITH CARD.TYPE NE '' "
    END

    LOCATE "REASON" IN D.FIELDS<1> SETTING REASON.POS THEN
        Y.CARD.REASON = D.RANGE.AND.VALUE<REASON.POS>
    END ELSE
        Y.CARD.REASON = ""
    END


    FROM.DATE.VALUE=''
    LOCATE "FROM.DATE" IN D.FIELDS<1> SETTING Y.DATE.POS THEN
        FROM.DATE.VALUE = D.RANGE.AND.VALUE<Y.DATE.POS>
    END

    UNTIL.DATE.VALUE=''
    LOCATE "UNTIL.DATE" IN D.FIELDS<1> SETTING Y.DAT.POS THEN
        UNTIL.DATE.VALUE = D.RANGE.AND.VALUE<Y.DAT.POS>
    END

    IF  FROM.DATE.VALUE NE '' AND UNTIL.DATE.VALUE NE '' THEN
        SEL.CMD:=' AND TIME.ENTRY GE ':FROM.DATE.VALUE :' AND TIME.ENTRY LE ':UNTIL.DATE.VALUE
        SEL.CMD.1:=' AND DATE.DL GE ':FROM.DATE.VALUE :' AND DATE.DL LE ':UNTIL.DATE.VALUE
    END

    IF FROM.DATE.VALUE NE '' AND UNTIL.DATE.VALUE EQ '' THEN
        UNTIL.DATE.VALUE = TODAY
        SEL.CMD:=' AND TIME.ENTRY GE ':FROM.DATE.VALUE:' AND TIME.ENTRY LE ':UNTIL.DATE.VALUE
        SEL.CMD.1:=' AND DATE.DL GE ':FROM.DATE.VALUE:' AND DATE.DL LE ':UNTIL.DATE.VALUE
    END

    IF FROM.DATE.VALUE EQ '' AND UNTIL.DATE.VALUE NE '' THEN
        SEL.CMD:=' AND TIME.ENTRY LE ':UNTIL.DATE.VALUE
        SEL.CMD.1:=' AND DATE.DL LE ':UNTIL.DATE.VALUE
    END

    IF FROM.DATE.VALUE EQ "" AND UNTIL.DATE.VALUE EQ "" THEN
        SEL.CMD:=" AND TIME.ENTRY NE '' "
        SEL.CMD.1:=" AND DATE.DL NE '' "
    END


    SEL.LIST = ''
    NO.OF.REC =''
    REC.ERR =''

    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.REC,REC.ERR)
    CALL EB.READLIST(SEL.CMD.1,SEL.LIST.V,"",NO.OF.REC.V,V.REC.ERR)
    LOOP
        REMOVE SEL.ID FROM SEL.LIST SETTING POS
    WHILE SEL.ID:POS

        R.REDO.CARD.DAMAGE =''
        REDO.CARD.DAMAGE.ERR =''
        CALL F.READ(FN.REDO.CARD.DMG.EMBOSS,SEL.ID,R.REDO.CARD.DAMAGE,F.REDO.CARD.DMG.EMBOSS,Y.ERR)

        Y.REDO.CARD.SERIES = R.REDO.CARD.DAMAGE<DMG.LST.OLD.SERIES>

        Y.SERIES = DCOUNT(Y.REDO.CARD.SERIES,@VM)

        CNT = 1
        FOR CNT = 1 TO Y.SERIES
            CURR.REDO.CARD.TYPE   = R.REDO.CARD.DAMAGE<DMG.LST.OLD.CARD.TYPE,CNT>
            IF R.REDO.CARD.DAMAGE<DMG.LST.OLD.LOST,CNT> GT 0 THEN
                REDO.CARD.ACT         = 'LOST'
                REDO.CARD.REASON.DAM=R.REDO.CARD.DAMAGE<DMG.LST.OLD.LOST.DESC,CNT>
            END
            IF R.REDO.CARD.DAMAGE<DMG.LST.OLD.DAMAGE,CNT> GT 0 THEN
                REDO.CARD.ACT<1,-1>        ='DAMAGED'
                REDO.CARD.REASON.DAM<1,-1> = R.REDO.CARD.DAMAGE<DMG.LST.OLD.DAM.DESC,CNT>
            END
            Y.DATE=R.REDO.CARD.DAMAGE<DMG.LST.TIME.ENTRY>
            GOSUB CARDSERIES
        NEXT CNT
    REPEAT


    LOOP
        REMOVE SEL.ID FROM SEL.LIST.V SETTING Y.V.POS
    WHILE SEL.ID:POS

        R.REDO.CARD.DAMAGE =''
        Y.ERR =''
        CALL F.READ(FN.REDO.CARD.DAMAGE.VIRGIN,SEL.ID,R.REDO.CARD.DAMAGE,F.REDO.CARD.DAMAGE.VIRGIN,Y.ERR)

        Y.REDO.CARD.SERIES = R.REDO.CARD.DAMAGE<CARD.RET.SERIES>

        Y.SERIES = DCOUNT(Y.REDO.CARD.SERIES,@VM)

        CNT = 1
        FOR CNT = 1 TO Y.SERIES
            CURR.REDO.CARD.TYPE       = R.REDO.CARD.DAMAGE<CARD.RET.CARD.TYPE,CNT>
            IF R.REDO.CARD.DAMAGE<CARD.RET.LOST,CNT> GT 0 THEN
                REDO.CARD.ACT         ='LOST'
                REDO.CARD.REASON.DAM  = R.REDO.CARD.DAMAGE<CARD.RET.LOST.DESC,CNT>
            END
            IF R.REDO.CARD.DAMAGE<CARD.RET.DAMAGE,CNT> GT 0 THEN
                REDO.CARD.ACT<1,-1>        ='DAMAGED'
                REDO.CARD.REASON.DAM<1,-1> = R.REDO.CARD.DAMAGE<CARD.RET.DAM.DESC,CNT>
            END
            Y.DATE=R.REDO.CARD.DAMAGE<CARD.RET.DATE.DL>
            GOSUB CARDSERIES
        NEXT CNT
    REPEAT
RETURN
*-----------------------------------------------------------------------------------------------------------------
***********
CARDSERIES:
***********

    IF Y.CARD.TYPE NE "" AND CURR.REDO.CARD.TYPE NE Y.CARD.TYPE THEN
        RETURN
    END
    R.CARD.TYPE         = ''
    CARD.TYPE.ERR       = ''
    CALL F.READ(FN.CARD.TYPE,CURR.REDO.CARD.TYPE,R.CARD.TYPE,F.CARD.TYPE,CARD.TYPE.ERR)
    CARD.TYPE.DESC.VAL  = ""
    CARD.TYPE.DESC.VAL  = R.CARD.TYPE<CARD.TYPE.DESCRIPTION>
    Y.CNT.FOR.DL.MAX=DCOUNT(REDO.CARD.ACT,@VM)
    Y.CNT.FOR.DL=1
    LOOP
    WHILE Y.CNT.FOR.DL LE Y.CNT.FOR.DL.MAX

        IF NOT(Y.CARD.REASON) THEN
            Y.DAM.RES=REDO.CARD.REASON.DAM<1,Y.CNT.FOR.DL>
            CHANGE @SM TO @VM IN Y.DAM.RES
            RETURN.DATA<-1>     = CARD.TYPE.DESC.VAL:"*":REDO.CARD.ACT<1,Y.CNT.FOR.DL>:"*":Y.DAM.RES:"*":Y.DATE
        END
        ELSE
            IF Y.CARD.REASON EQ REDO.CARD.ACT<1,Y.CNT.FOR.DL> THEN
                Y.DAM.RES=REDO.CARD.REASON.DAM<1,Y.CNT.FOR.DL>
                CHANGE @SM TO @VM IN Y.DAM.RES
                RETURN.DATA<-1>     = CARD.TYPE.DESC.VAL:"*":REDO.CARD.ACT<1,Y.CNT.FOR.DL>:"*":Y.DAM.RES:"*":Y.DATE
            END
        END
        Y.CNT.FOR.DL += 1
    REPEAT
    CARD.TYPE.DESC.VAL  =''
    REDO.CARD.ACT       =''
    REDO.CARD.REASON.DAM=''
RETURN

END
