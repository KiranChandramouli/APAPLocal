$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.LIST.TELLER.ID(Y.ARRAY.OUT)

* Item ID        : GDC-384
*-------------------------------------------------------------------------------------
* Description :
* ------------
* This program merges HISTORY, LIVE and $NAU TELLER.ID files to get a set of data,
*  stating from specific filters.
*-------------------------------------------------------------------------------------
* Modification History :
* ----------------------
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2019/05/13     Raquel P.S.         Initial development
*-------------------------------------------------------------------------------------
* Content summary :
* -----------------
* Enquiry                          : LAPAP.ENQ.RPT.LAB.CAJEROS
* STANDARD.SELECTION : NOFILE.LAPAP.TELLER.ID.MERGE
* EB.API                         : L.APAP.LIST.TELLER.ID
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - ELSE IF to splitted to ELSE and IF , < to LT , F.READ to CACHE.READ , I to I.VAR , Include to Insert and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - No changes   
*-------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER.ID
    $INSERT I_F.COMPANY

    GOSUB INIT
    GOSUB PROCESS
    GOSUB FORM.FINAL.ARRAY
    GOSUB PGM.END
RETURN

*------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------
* Variables and files are opened here

    FN.TT.ID = 'F.TELLER.ID'
    F.TT.ID = ''
    CALL OPF(FN.TT.ID, F.TT.ID)

    FN.TT.ID.NAU = 'F.TELLER.ID$NAU'
    F.TT.ID.NAU = ''
    CALL OPF(FN.TT.ID.NAU, F.TT.ID.NAU)

    FN.TT.ID.HIS = 'F.TELLER.ID$HIS'
    F.TT.ID.HIS = ''
    CALL OPF(FN.TT.ID.HIS, F.TT.ID.HIS)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY= ''
    CALL OPF(FN.COMPANY, F.COMPANY)

    Y.SUF="L"; FN.TABLE=FN.TT.ID; F.TABLE=F.TT.ID; Y.ARR.T.ID=''; Y.ARRAY=''; Y.VAR1=1; Y.CURR.NO='';

RETURN

*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
*Get enquiry selection inputted by user

    LOCATE "CO.CODE" IN D.FIELDS<1> SETTING CO.CODE.POS THEN
        Y.CO.CODE = D.RANGE.AND.VALUE<CO.CODE.POS>
    END

    LOCATE "DATE.OF.CLOSE" IN D.FIELDS<1> SETTING D.CLOSE.POS THEN
        Y.DATE.OF.CLOSE = D.RANGE.AND.VALUE<D.CLOSE.POS>
    END

    FOR I.VAR= 1 TO 2 STEP 1
        GOSUB FORM.SELECT
    NEXT I.VAR

    Y.SUF="H"
    FN.TABLE=FN.TT.ID.HIS
    F.TABLE=F.TT.ID.HIS
    GOSUB FORM.SELECT

RETURN

*-------------------------------------------------------------------------
FORM.SELECT:
*-------------------------------------------------------------------------
*Selection declaration form based on the available query selection data.

    SEL.CMD = "SELECT " :FN.TABLE

    IF Y.CO.CODE AND Y.DATE.OF.CLOSE THEN
        SEL.CMD := " WITH CO.CODE EQ ": Y.CO.CODE : " AND DATE.OF.CLOSE EQ ": Y.DATE.OF.CLOSE :" AND L.TT.USER.TYPE EQ TELLER BY-DSND CURR.NO"
        COND.CMD.HIST= "... AND CO.CODE EQ ": Y.CO.CODE : " AND DATE.OF.CLOSE EQ ": Y.DATE.OF.CLOSE : " AND L.TT.USER.TYPE EQ TELLER"
    END
    ELSE
        IF NOT(Y.CO.CODE) AND Y.DATE.OF.CLOSE THEN
            SEL.CMD := " WITH DATE.OF.CLOSE EQ ": Y.DATE.OF.CLOSE :" AND L.TT.USER.TYPE EQ TELLER BY-DSND CURR.NO"
            COND.CMD.HIST="... AND DATE.OF.CLOSE EQ ": Y.DATE.OF.CLOSE :" AND L.TT.USER.TYPE EQ TELLER BY-DSND CURR.NO"
        END
        ELSE
            IF Y.CO.CODE AND NOT(Y.DATE.OF.CLOSE) THEN
                SEL.CMD = " WITH CO.CODE EQ ": Y.CO.CODE :" AND L.TT.USER.TYPE EQ TELLER BY-DSND CURR.NO"
                COND.CMD.HIST="... AND CO.CODE EQ ": Y.CO.CODE :" AND L.TT.USER.TYPE EQ TELLER BY-DSND CURR.NO"
            END
            ELSE
                IF NOT(Y.CO.CODE) AND NOT(Y.DATE.OF.CLOSE) THEN
                    SEL.CMD = " WITH CO.CODE EQ ": Y.CO.CODE :" AND L.TT.USER.TYPE EQ TELLER BY-DSND CURR.NO "
                    COND.CMD.HIST=""
                END
            END
        END
    END

    CALL EB.READLIST(SEL.CMD, SEL.LIST.GRAL,"", NO.OF.REC.GRAL, SEL.ERR)


*The matrix jumps to the HIST process when Hist file, otherwise, it iterates between LIVE and NAU til DATASET is got.

    IF Y.SUF NE "H" THEN
        GOSUB LIST.TELLER.ID.LIV.NAU
    END ELSE
        GOSUB LIST.TELLER.ID.HIST
    END
RETURN

*-------------------------------------------------------------------------
LIST.TELLER.ID.LIV.NAU:
*-------------------------------------------------------------------------
*Extraction process for $NAU and Live table. When Hist file, matrix is skipped to HIST process.

    IF SEL.LIST.GRAL  THEN
        Y.ARR.T.ID<-1>:=SEL.LIST.GRAL
    END
    Y.SUF="N"
    FN.TABLE=FN.TT.ID.NAU
    F.TABLE=F.TT.ID.NAU

RETURN

*-------------------------------------------------------------------------
LIST.TELLER.ID.HIST:
*-------------------------------------------------------------------------
*Extraction process for Hist table. It avoids duplication, by detecting whether a teller.id has already been read
*in NAU or LIVE table as primary sources.

    IF SEL.LIST.GRAL THEN
        LOOP
            REMOVE Y.TELLER.ID FROM SEL.LIST.GRAL SETTING TELLER.ID.POS
        WHILE Y.TELLER.ID:TELLER.ID.POS

            Y.ID=LEFT(Y.TELLER.ID,4)

            IF Y.ID NE Y.CAJA THEN
                Y.CAJA=Y.ID
                Y.ID.DUP=COUNT (Y.ARR.T.ID,Y.ID)
                IF NOT(Y.ID.DUP) THEN
                    GOSUB CHECK.LAST.REC.HIST
                    Y.ARR.T.ID<-1>:= T.ID.HIS.LAST
                END

            END

        REPEAT
    END

RETURN


*-------------------------------------------------------------------------
CHECK.LAST.REC.HIST:
*-------------------------------------------------------------------------
*Process to get last record within given condition from HIST.

    SEL.CMD.HIS = "SELECT " :FN.TABLE : " WITH @ID LIKE " :  Y.CAJA : COND.CMD.HIST

    CALL EB.READLIST(SEL.CMD.HIS, SEL.LIST.INDV,"", NO.OF.REC.GRAL, SEL.ERR)

    LOOP
        REMOVE T.ID.HIS FROM SEL.LIST.INDV SETTING T.ID.HIS.POS
    WHILE T.ID.HIS:T.ID.HIS.POS

        ID.LENGHT=LEN(T.ID.HIS)
        COMMA.POS=INDEX(T.ID.HIS, ";",1)
        CURR.FROM.ID=SUBSTRINGS(T.ID.HIS,COMMA.POS+1,ID.LENGHT)

        IF Y.MIN EQ "" THEN
            Y.MIN=CURR.FROM.ID
        END ELSE
            IF Y.MIN LT CURR.FROM.ID THEN
                Y.MIN=Y.MIN
            END ELSE
                Y.MIN=CURR.FROM.ID
            END
        END
    REPEAT
    T.ID.HIS.LAST= Y.CAJA:";":Y.MIN
    Y.MIN=""

RETURN

*------------------------------------------------------------------------
FORM.FINAL.ARRAY:
*------------------------------------------------------------------------
*Get fields from respective tables, join them into a single array.

    LOOP
        REMOVE Y.TELLER.ID FROM Y.ARR.T.ID SETTING TELLER.ID.POS
    WHILE Y.TELLER.ID:TELLER.ID.POS

        Y.CAJA.ARR=LEFT(Y.TELLER.ID,4)

        CALL F.READ(FN.TT.ID.NAU,Y.TELLER.ID,ARR.RESULT.NAU,F.TT.ID.NAU,ARR.ERR.NAU)
        CALL F.READ(FN.TT.ID,Y.TELLER.ID,ARR.RESULT.LIV,F.TT.ID,ARR.ERR.LIV)
        CALL F.READ(FN.TT.ID.HIS,Y.TELLER.ID,ARR.RESULT.HIS,F.TT.ID.HIS,ARR.ERR.HIS)

        IF ARR.RESULT.NAU THEN
            SET.ARRAY=ARR.RESULT.NAU
            Y.STATUS="(Estatus ":SET.ARRAY<TT.TID.RECORD.STATUS>:")"
        END
        ELSE
            IF ARR.RESULT.LIV THEN
                SET.ARRAY=ARR.RESULT.LIV
            END
            ELSE
                IF ARR.RESULT.HIS  THEN
                    SET.ARRAY=ARR.RESULT.HIS
                END
            END
        END

        Y.CAJA.ARR=LEFT(Y.TELLER.ID,4)
        Y.CO.CODE.ARR=SET.ARRAY<TT.TID.CO.CODE>
        CALL CACHE.READ(FN.COMPANY, Y.CO.CODE.ARR, R.COMP, Y.ERR.COMP)	;*R22 Auto Conversion  - F.READ to CACHE.READ
        Y.ARRAY:=Y.CAJA.ARR
        Y.ARRAY:='*':SET.ARRAY<TT.TID.USER>
        Y.ARRAY:='*':Y.CO.CODE.ARR:", ":R.COMP<EB.COM.COMPANY.NAME>
        Y.ARRAY:='*':SET.ARRAY<TT.TID.DATE.OF.OPEN>
        Y.ARRAY:='*':SET.ARRAY<TT.TID.DATE.OF.CLOSE>
        Y.ARRAY:='*':SET.ARRAY<TT.TID.STATUS>:" ":Y.STATUS:@FM

    REPEAT

    GOSUB ARRAY.OUT
RETURN


*------------------------------------------------------------------------
ARRAY.OUT:
*------------------------------------------------------------------------
    Y.ARRAY.OUT:=Y.ARRAY
RETURN

*---------------------------------------------------------------------------
PGM.END:
*---------------------------------------------------------------------------
END
