SUBROUTINE REDO.STLMT.BIN.VALIDATE
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.STLMT.BIN.VALIDATE
*********************************************************
*DESCRIPTION: This routine will validate the BIN for settlement process
* When the BIN is not APAP bin or APAP DEBIT Card bin and wrong card number will throw error


*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.VISA.STLMT.FILE.PROCESS
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*01.12.2010  H GANESH        ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------




    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
*$INCLUDE TAM.BP I_REDO.ATH.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.CARD.BIN



    IF ERROR.MESSAGE NE '' THEN
        RETURN
    END

    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    Y.BIN.NUMBER = Y.FIELD.VALUE[1,6]

    CALL F.READ(FN.REDO.CARD.BIN,Y.BIN.NUMBER,R.REDO.CARD.BIN,F.REDO.CARD.BIN,CARD.BIN.ERR)
*
    IF R.REDO.CARD.BIN EQ '' THEN
        ERROR.MESSAGE = "CARD.NUM.DOESNT.EXIST"
        RETURN
    END ELSE
        APAP.BIN = R.REDO.CARD.BIN<REDO.CARD.BIN.BIN.OWNER>
        BIN.TYPE = R.REDO.CARD.BIN<REDO.CARD.BIN.BIN.TYPE>
    END
*
    IF APAP.BIN EQ 'APAP' AND BIN.TYPE EQ 'CREDIT' THEN
        CONT.FLAG = 'TRUE'
        RETURN
    END
*
    IF APAP.BIN EQ 'NONAPAP' THEN
        ERROR.MESSAGE = 'CARD.NUM.DOESNT.EXIST'
        RETURN
    END
*
    IF APAP.BIN EQ 'APAP' AND BIN.TYPE EQ 'DEBIT' THEN
        CARD.TYPE.VAL = R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
    END
*
*    changing code to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279

    LOOP
        REMOVE CRD.TYP FROM CARD.TYPE.VAL SETTING POS.CRD
    WHILE CRD.TYP:POS.CRD

        R.LATAM.CARD.ORDER=''
        LCO.ID = CRD.TYP:'.':Y.FIELD.VALUE
        CALL F.READ(FN.LATAM.CARD.ORDER,LCO.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,CARD.ORDER.ERR)

        IF R.LATAM.CARD.ORDER THEN
            CARD.TYPE.VAL=CRD.TYP

            BREAK
        END
    REPEAT
* Updating end multivalue field CARD.TYPE in REDO.CARD.BIN PACS00033279

*
    IF R.LATAM.CARD.ORDER EQ '' THEN
        CHECK.ADD.DIGIT = 'TRUE'
    END ELSE
        NATIONAL.FLAG = R.REDO.CARD.BIN<REDO.CARD.BIN.NATIONAL.MARK>
    END
*
RETURN
END
