SUBROUTINE APAP.DYN.CONV.RTN

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ENQUIRY
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.APAP.PARAM.DB.CR.MASK

*This is the Conversion routine to Mask the values in the field(mentioned in the  parameter table - APAP.PARAM.DB.CR.MASK)
*of the corresponding Enquiry(mentioned in the parameter table - APAP.PARAM.DB.CR.MASK)
*Nishant

    Y.ENQ.ID = ENQ.SELECTION<1>

    FN.APAP.PARAM.DB.CR.MASK = "F.APAP.PARAM.DB.CR.MASK"
    F.APAP.PARAM.DB.CR.MASK = ""
    CALL OPF(FN.APAP.PARAM.DB.CR.MASK,F.APAP.PARAM.DB.CR.MASK)

    Y.CARD.VALUE = O.DATA
    Y.CARD.TYPE = NUM(Y.CARD.VALUE[1,4])
    IF Y.CARD.TYPE "1" THEN   ;*Card number startes with number
        Y.CARD.NUM = O.DATA
        GOSUB MASK.CARD.NUM
        O.DATA = Y.MASK.CARD.NUM
    END ELSE        ;*Card number starts with its Type
        Y.CARD.TYPE = O.DATA[1,5]
        Y.CARD.NUM = O.DATA[6,LEN(O.DATA)]
        GOSUB MASK.CARD.NUM
        O.DATA = Y.CARD.TYPE:Y.MASK.CARD.NUM
    END
    Y.MASK.DIGIT = ""

RETURN

MASK.CARD.NUM:

    Y.INT = 1
    Y.LEN.CARD = LEN(Y.CARD.NUM)
    CALL F.READ(FN.APAP.PARAM.DB.CR.MASK,Y.ENQ.ID,R.MASK.PARAM,F.APAP.PARAM.DB.CR.MASK,ERR.MASK.PARAM)
    IF R.MASK.PARAM THEN
        Y.PARAM.DIGIT = R.MASK.PARAM<APAP.MASK.MASKING.DIGITS>
        CHANGE " " TO @FM IN Y.PARAM.DIGIT
        LOOP
        WHILE Y.INT LE Y.LEN.CARD
            Y.QUO = Y.INT/4
            Y.QUO.DEC = FIELD(Y.QUO,".",2,1)
            LOCATE Y.INT IN Y.PARAM.DIGIT SETTING Y.DIGI.POS THEN
                IF (Y.QUO.DEC NE "") OR (Y.INT EQ Y.LEN.CARD) THEN
                    Y.MASK.CARD.NUM := "*"
                END ELSE
                    Y.MASK.CARD.NUM := "*-"
                END
            END ELSE
                IF (Y.QUO.DEC NE "") OR (Y.INT EQ Y.LEN.CARD) THEN
                    Y.MASK.CARD.NUM := Y.CARD.NUM[Y.INT,1]
                END ELSE
                    Y.MASK.CARD.NUM := Y.CARD.NUM[Y.INT,1]:"-"
                END
            END
            Y.INT += 1
        REPEAT
    END

RETURN

END
