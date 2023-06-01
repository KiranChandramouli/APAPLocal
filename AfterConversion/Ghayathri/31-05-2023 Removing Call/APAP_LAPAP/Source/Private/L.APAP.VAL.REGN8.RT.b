* @ValidationCode : MjotMTY4NjMyMDE3NjpDcDEyNTI6MTY4MjMzNTk0NTE5NDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VAL.REGN8.RT
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* AUTO R22 CODE CONVERSION END


    Y.FIELD.NAME = R.NEW(REDO.REP.PARAM.FIELD.NAME)
    Y.FIELD.VAL  = R.NEW(REDO.REP.PARAM.FIELD.VALUE)
    STR.DATE = ''; END.DATE = ''

    LOCATE 'FROM.DATE' IN Y.FIELD.NAME<1,1> SETTING Y.FRM.POS THEN
        STR.DATE = Y.FIELD.VAL<1,Y.FRM.POS>
    END
    LOCATE 'TO.DATE' IN Y.FIELD.NAME<1,1> SETTING Y.TO.POS THEN
        END.DATE = Y.FIELD.VAL<1,Y.TO.POS>
    END

    IF (STR.DATE EQ '') OR (END.DATE EQ '') THEN
        MESSAGE = "PARAMETROS FROM.DATE Y TO.DATE NO PUEDEN ESTAR EN BLANCO."
        E = MESSAGE
        ETEXT = E
        CALL ERR
    END
    IF END.DATE LT STR.DATE THEN
        MESSAGE = "LA FECHA FINAL NO PUEDE SER  INFERIOR A LA FECHA INICIAL."
        E = MESSAGE
        ETEXT = E
        CALL ERR
    END



END
