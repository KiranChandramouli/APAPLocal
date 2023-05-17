SUBROUTINE ISO.PARSER

*/  Program to help consulatants parse the iso messages !!!! */
* / gp/23/04/04   - FOR 87 Version

    $INSERT I_COMMON
    $INSERT I_EQUATE
*

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN


INITIALISE:
*-----------*
    DIM FLD.LEN(123)
    FLD.LEN(1) = "16"
    FLD.LEN(2) = "19LL"
    FLD.LEN(3) = 6
    FLD.LEN(4) = 12
    FLD.LEN(5) = 12
    FLD.LEN(6) = 12
    FLD.LEN(7) = 10
    FLD.LEN(10) = 8
    FLD.LEN(11) = 6
    FLD.LEN(12) =6
    FLD.LEN(13) =4
    FLD.LEN(14) =4
    FLD.LEN(15) =4
    FLD.LEN(18) =4
    FLD.LEN(19) =3
    FLD.LEN(22) =3
    FLD.LEN(23) =3
    FLD.LEN(24) =3
    FLD.LEN(25) =2
    FLD.LEN(26) =2
    FLD.LEN(28) =9
    FLD.LEN(29) = 9
    FLD.LEN(30) =9
    FLD.LEN(32) ="11LL"
    FLD.LEN(33) ="11LL"
    FLD.LEN(35) ="37LL"
    FLD.LEN(37) = 12
    FLD.LEN(38) = 6
    FLD.LEN(39) = 2
    FLD.LEN(40) = 3
    FLD.LEN(41) = 8
    FLD.LEN(42) = 15
    FLD.LEN(43) ="40"
    FLD.LEN(44) = "25"
    FLD.LEN(46) ="204LLL"
    FLD.LEN(48) ="999LLLCHAR"
    FLD.LEN(49) =3
    FLD.LEN(51) =3
    FLD.LEN(52) = 16
    FLD.LEN(53) =16

    FLD.LEN(54) ="120LLLCHAR"
    FLD.LEN(56) ="999LLLCHAR"
    FLD.LEN(70) = "3"
    FLD.LEN(100) = "11LL"
    FLD.LEN(102) ="19LLCHAR"
    FLD.LEN(103) ="28LLCHAR"
    FLD.LEN(123) ="999LLLCHAR"
    FIELDS.PRESENT = ''
    FIELDS.PRESENT.ARR = ''
RETURN          ;*From initialise

*---------------------------------------------------------------*

PROCESS:
*------*

    PRINT 'Please enter the message'
    INPUT ISO.MESSAGE

    IF NOT(ISO.MESSAGE) THEN
        RETURN
    END
    PRINT  '                   '
    PRINT  '                        '
    LEN.ISO.MESSAGE = ISO.MESSAGE[1,4]
    PRINT  "Length of the ISO message  is ->":LEN.ISO.MESSAGE
    MESG.TYP.IND = ISO.MESSAGE[5,4]
    HEX.BIT.MAP = ISO.MESSAGE[9,16]
    IF ISO.MESSAGE[9,1] EQ 'f' OR ISO.MESSAGE[9,1] EQ 'F' THEN

        HEX.BIT.MAP:= ISO.MESSAGE[25,16]
        SECONDARY.BIT.MAP = 'Y'
    END
    PRINT "MTI--->":MESG.TYP.IND


    HEX.BIT.MAP = UPCASE(HEX.BIT.MAP)
    PRINT HEX.BIT.MAP
    BIN.BIT.MAP = OCONV(HEX.BIT.MAP,"MCXB")
    PRINT "Press Enter <-| "
    INPUT XYZ
    PRINT "BIT-MAP--->":BIN.BIT.MAP
    CHANGE ' ' TO '' IN BIN.BIT.MAP

    FOR II =1 TO LEN(BIN.BIT.MAP)
        IF BIN.BIT.MAP[II,1] EQ '1' THEN
            FIELDS.PRESENT := ' ':II
            FIELDS.PRESENT.ARR<-1> =II

        END

    NEXT II

    PRINT "Press Enter <-| "
    INPUT XYZ
    PRINT "FIELDS.PRESENT->":FIELDS.PRESENT


    INPUT XYZ

    IF SECONDARY.BIT.MAP EQ 'Y' THEN
        MSG.CONTENT.START.POSN = 41
    END ELSE
        MSG.CONTENT.START.POSN = 25
    END
    CNT = DCOUNT(FIELDS.PRESENT.ARR,@FM)

    START.POSN = MSG.CONTENT.START.POSN
*

    FOR KK =2 TO 123

        FIND KK IN FIELDS.PRESENT.ARR SETTING POSN ELSE POSN =''

        IF POSN THEN
            IF INDEX(FLD.LEN(KK),'LLL',1) THEN
                LEN.OF.FIELD = ISO.MESSAGE[START.POSN,3]
                START.POSN+=3

                FIELD.VAL = ISO.MESSAGE[START.POSN,LEN.OF.FIELD]


            END ELSE

                IF INDEX(FLD.LEN(KK),'LL',1) THEN
                    LEN.OF.FIELD = ISO.MESSAGE[START.POSN,2]
                    START.POSN +=2
                    FIELD.VAL = ISO.MESSAGE[START.POSN,LEN.OF.FIELD]


                END ELSE
                    LEN.OF.FIELD = FLD.LEN(KK)

                    FIELD.VAL = ISO.MESSAGE[START.POSN,LEN.OF.FIELD]



                END
            END


            START.POSN+= LEN.OF.FIELD

            IF FIELD.VAL NE '' THEN
                PRINT  "<":KK:">":"<": FIELD.VAL :">"
            END
        END
    NEXT KK


    PRINT "Press Enter <-| "
    INPUT XYZ

RETURN          ;*From process
*--------------------------------------------------------------------*
