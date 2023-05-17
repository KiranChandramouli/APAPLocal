SUBROUTINE S.REDO.BUILD.SELECT.COMM(R.IN.APPLICATION,R.IN.COND.DEF,R.OUT.SEL.CMD,P.OUT.MSG.ERR)

*-----------------------------------------------------------------------------

*

* Description: Single Routine, allows to

*              1. build a select command with a list of applications,operators

*                 and values

*-----------------------------------------------------------------------------
* PARAMETERS:
* INPUT:
*       R.IN.APPLICATION -> Application list
*       R.IN.COND.DEF    -> Conditions List
*
* OUTPUT:
*
*       R.OUT.SEL.CMD   -> Select command build for the input data
*                          (1) - Fields
*                          (2) - Operators
*                          (3) - Values
*                          (4) - Logic Operators
*       P.OUT.MSG.ERR   -> Error Message
*
*-----------------------------------------------------------------------------
* Modification History:
*                      2011-04-15 : avelasco@temenos.com
*                                   First version
*REM Just for compile
*-----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN

* ========
PROCESS:
* ========
*
*  Principal process to build a select comand with the data inputed
*

    Y.REL.CMD = ''
    Y.NO.FIELDS = DCOUNT(R.IN.APPLICATION,@VM)

    FOR Y.POS = 1 TO Y.NO.FIELDS

        BEGIN CASE
            CASE R.IN.COND.DEF<2,Y.POS> EQ 'EQ'
                Y.VALUES.COMP = CHANGE(R.IN.COND.DEF<3,Y.POS>,@SM,' ')
                Y.REL.CMD = R.IN.COND.DEF<1,Y.POS> : ' EQ ' : Y.VALUES.COMP

            CASE R.IN.COND.DEF<2,Y.POS> EQ 'MATCHES'
                Y.REL.CMD = R.IN.COND.DEF<1,Y.POS> : ' MATCHES ' :R.IN.COND.DEF<3,Y.POS>

            CASE R.IN.COND.DEF<2,Y.POS> EQ 'NE'
                Y.VAL.LIST = R.IN.COND.DEF<3,Y.POS>
                LOOP
                    REMOVE Y.VALUE FROM Y.VAL.LIST SETTING Y.X
                WHILE Y.VALUE : Y.X
                    Y.REL.CMD = R.IN.COND.DEF<1,Y.POS> : ' NE ' : Y.VALUE : ' AND '
                REPEAT
                Y.X = LEN(Y.REL.CMD)
                Y.REL.CMD = Y.REL.CMD[1,Y.X-6]

            CASE R.IN.COND.DEF<2,Y.POS> EQ 'RG'
                Y.REL.CMD = R.IN.COND.DEF<1,Y.POS>: ' GE ' :R.IN.COND.DEF<3,Y.POS,1> : ' AND ' :R.IN.COND.DEF<1,Y.POS> : ' LE ' : R.IN.COND.DEF<3,Y.POS,2>

            CASE R.IN.COND.DEF<2,Y.POS> EQ 'NR'
                Y.REL.CMD = 'NOT(': R.IN.COND.DEF<1,Y.POS>: ' GE ' :R.IN.COND.DEF<3,Y.POS,1> : ' AND ' :R.IN.COND.DEF<1,Y.POS> : ' LE ' :R.IN.COND.DEF<3,Y.POS,2> :')'

            CASE 1
                P.OUT.MSG.ERR = "ST-REDO.CCRG.INVALID.ARGUMENT"
                PROCESS.GOAHEAD = 0
                Y.POS = Y.NO.FIELDS
        END CASE

        IF PROCESS.GOAHEAD THEN
            Y.REL.CMD := R.IN.COND.DEF<4,Y.POS>
        END

        GOSUB OPEN.FILES

        Y.REL.CMD = 'SELECT ' : FN.APPLICATION :' WITH ' : Y.REL.CMD

        R.OUT.SEL.CMD<Y.POS> = Y.REL.CMD

    NEXT Y.POS

*
RETURN
*
* ===========
INITIALISE:
* ===========
*
*  Paragraph to initialise variables
*
    PROCESS.GOAHEAD             = 1
    R.OUT.SEL.CMD               = ''
    P.OUT.MSG.ERR               = ''
*
RETURN
*
* =========
OPEN.FILES:
* =========
*
*  Open File
*

    FN.APPLICATION  = 'F.':R.IN.APPLICATION<Y.POS>
    F.APPLICATION  = ''
    CALL OPF(FN.APPLICATION,F.APPLICATION)


RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
* Validate the input data
*
    IF R.IN.APPLICATION EQ '' THEN
        PROCESS.GOAHEAD = 0
        P.OUT.MSG.ERR= 'ST-REDO.CCRG.APPLICATION.NO.INPUT'
    END

    IF R.IN.COND.DEF<1> EQ '' THEN
        PROCESS.GOAHEAD = 0
        P.OUT.MSG.ERR = 'ST-REDO.CCRG.FIELD.NO.INPUT'
    END

    IF R.IN.COND.DEF<2> EQ '' THEN
        PROCESS.GOAHEAD = 0
        P.OUT.MSG.ERR = 'ST-REDO.CCRG.OPERATOR.NO.INPUT'
    END

    IF R.IN.COND.DEF<3> EQ '' THEN
        PROCESS.GOAHEAD = 0
        P.OUT.MSG.ERR = 'ST-REDO.CCRG.VALUE.NO.INPUT'
    END



*
RETURN

********
END
