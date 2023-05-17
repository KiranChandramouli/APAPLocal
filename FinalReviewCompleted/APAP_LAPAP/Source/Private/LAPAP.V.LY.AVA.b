* @ValidationCode : Mjo4MzY2NjIxMjpDcDEyNTI6MTY4NDIyMjgxNzgwNDpJVFNTOi0xOi0xOjM5OToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 399
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.V.LY.AVA
* @(#) LAPAP.V.LY.AVA Ported to jBASE 16:17:00  28 NOV 2017
*--------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*21-04-2023            Conversion Tool             R22 Auto Code conversion                      INSERT FILE MODIFIED,= TO EQ,< TO LT
*21-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.POINTS.US
    $INSERT I_F.REDO.LY.POINTS.TOT
    $INSERT I_F.REDO.LY.PROGRAM    ;*R22 AUTO CODE CONVERSION.END


    FN.LY = "F.REDO.LY.POINTS.TOT"
    FV.LY= ""
    R.LY = ""
    LY.ERR = ""

    CALL OPF(FN.LY,FV.LY)

    FN.LP = "F.REDO.LY.PROGRAM"
    FV.LP= ""
    R.LP = ""
    LP.ERR = ""

    CALL OPF(FN.LP,FV.LP)


    Y.LY.AMOUNT = COMI

    Y.LY.NO = R.NEW(REDO.PT.US.CUSTOMER.NO) :"C"
    Y.LY.N2 = R.NEW(REDO.PT.US.CUSTOMER.NO)

    Y.ID.PR = R.NEW(REDO.PT.US.PROGRAM)

    Y.TP = R.NEW(REDO.PT.US.QTYORVAL)

    IF Y.LY.NO NE "" THEN

        CALL F.READ(FN.LY,Y.LY.NO,R.LY,FV.LY,LY.ERR)

        CALL F.READ(FN.LP,Y.ID.PR,R.LP,FV.LP,LP.ERR)

        Y.AVA = R.LY<REDO.PT.T.TOT.AVAIL.POINTS>

        Y.TASA = R.LP<REDO.PROG.POINT.VALUE>


        SEL.CMD = "SELECT F.REDO.LY.POINTS.TOT TOT.AVAIL.POINTS WITH @ID LIKE ":Y.LY.N2:"... ":"AND @ID LIKE ...ALL... AND @ID LIKE ...":Y.ID.PR:"..."
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)

        TT = SUM(SEL.LIST)



        IF Y.TP EQ "Puntos" THEN

            R.NEW(REDO.PT.US.QTY.VALUE) = FMT((Y.LY.AMOUNT * Y.TASA),0)
            R.NEW(REDO.PT.US.QUANTITY) = INT(Y.LY.AMOUNT)

*           DEBUG


        END

        IF Y.TP EQ "Monto" THEN

            R.NEW(REDO.PT.US.QTY.VALUE) =  INT(Y.LY.AMOUNT)
            R.NEW(REDO.PT.US.QUANTITY) = INT(Y.LY.AMOUNT/Y.TASA)

            Y.LY.AMOUNT = INT(Y.LY.AMOUNT/Y.TASA)

        END


        IF TT LT Y.LY.AMOUNT THEN

            ETEXT = "NO PUEDE INGRESAR UNA CANTIDAD SUPERIOR A LO DISPONIBLE "

            CALL STORE.END.ERROR
        END

    END



END
