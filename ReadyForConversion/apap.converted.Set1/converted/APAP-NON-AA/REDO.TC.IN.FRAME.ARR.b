SUBROUTINE  REDO.TC.IN.FRAME.ARR(STLMT.LINES)
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.TC.IN.FRAME.ARR
*Date              : 23.11.2010
*-------------------------------------------------------------------------
*Description:
*--------------
*This routine is used in process of building array for settlement line of transaction code 05
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --STLMT.LINES--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date             Name                        Reference            Version
* -------          ----                        ----------           --------
* 23/11/2010       saktharrasool@temenos.com   ODR-2010-08-0469     Initial Version
* 26-Nov-2018      Vignesh Kumaar M R          CI#2795720           BRD001 - FAST FUNDS SERVICES
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.VISA.STLMT.PARAM
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_F.REDO.VISA.STLMT.MAPPING
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------
    ERROR.MESSAGE=''

RETURN
*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

    STLMT.CNT=DCOUNT(STLMT.LINES,@FM)
    OTHR.TCR.ARR=''
    LINE.CNT=1
    LOOP

    WHILE LINE.CNT LE STLMT.CNT
        TCR.NO= STLMT.LINES<LINE.CNT>[4,1]
        IF TCR.NO NE 0 AND TCR.NO NE 1 THEN

* Fix for 2795720 [BRD001 - FAST FUNDS SERVICES]

            IF STLMT.LINES<LINE.CNT>[1,3] EQ '062' THEN
                SET.OCT.FLAG = 1
            END

* End of Fix

            OTHR.TCR.ARR<1,-1>= STLMT.LINES<LINE.CNT>
            LINE.CNT += 1
            CONTINUE
        END
        Y.VISA.STLMT.ID=TC.CODE:TCR.NO
        CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,Y.VISA.STLMT.ID,R.REDO.VISA.STLMT.MAPPING,F.REDO.VISA.STLMT.MAPPING,STLMT.ERR)

        IF R.REDO.VISA.STLMT.MAPPING NE '' THEN
            Y.FIELD.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
            CHANGE @VM TO @FM IN Y.FIELD.NAME

            LOCATE 'USAGE.CODE' IN Y.FIELD.NAME SETTING FLD.POS THEN
                Y.USAGE.CODE.ST.POS=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.START.POS,FLD.POS>
                Y.USAGE.CODE.ED.POS=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.END.POS,FLD.POS>
                Y.USAGE.CODE.VAL= STLMT.LINES<LINE.CNT>[Y.USAGE.CODE.ST.POS,Y.USAGE.CODE.ED.POS]
                IF Y.USAGE.CODE.VAL EQ 2 THEN
                    ERROR.MESSAGE='USAGE.CODE'
                END
            END


            GOSUB FIELD.WISE.PROCESS

        END
        LINE.CNT += 1
    REPEAT

RETURN
*------------------------------------------------------------------------------------
FIELD.WISE.PROCESS:
*------------------------------------------------------------------------------------
    VAR1=1
    Y.FIELD.CNT=DCOUNT(Y.FIELD.NAME,@FM)
    LOOP
    WHILE VAR1 LE Y.FIELD.CNT
        Y.FIELD.ST.POS=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.START.POS,VAR1>
        Y.FIELD.ED.POS=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.END.POS,VAR1>
        Y.FIELD.VALUE=STLMT.LINES<LINE.CNT>[Y.FIELD.ST.POS,Y.FIELD.ED.POS]

        IF R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.VERIFY.IN.RTN,VAR1> NE '' THEN
            Y.RTN.NAME=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.VERIFY.IN.RTN,VAR1>
            CALL @Y.RTN.NAME
        END
        IF CONT.FLAG EQ 'TRUE' THEN
            RETURN
        END
        Y.FIELD.NO=R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NO,VAR1>
        IF Y.FIELD.NO NE '' THEN
            R.REDO.STLMT.LINE<Y.FIELD.NO>=Y.FIELD.VALUE
        END

        VAR1 += 1
    REPEAT


RETURN
END
