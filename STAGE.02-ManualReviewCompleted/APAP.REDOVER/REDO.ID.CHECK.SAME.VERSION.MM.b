* @ValidationCode : MjoxOTkyOTQwNzgxOkNwMTI1MjoxNjgwNzc5MzQ0NjYzOm11dGh1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 16:39:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : muthu
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.ID.CHECK.SAME.VERSION.MM

*MODIFICATION HISTORY:

*-------------------------------------------------------------------------------

* DATE			WHO			 REFERENCE		DESCRIPTION

* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE

*-------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.REDO.SC.MM.VERSION.PARAM

MAIN:

    FN.REDO.SC.MM.VERSION.PARAM = 'F.REDO.SC.MM.VERSION.PARAM'
    F.REDO.SC.MM.VERSION.PARAM = ''
    CALL OPF(FN.REDO.SC.MM.VERSION.PARAM,F.REDO.SC.MM.VERSION.PARAM)

    MATBUILD NEW.VAL FROM R.NEW
    IF NOT(NEW.VAL) THEN
        RETURN
    END ELSE
        Y.VERSION = APPLICATION:PGM.VERSION
        CALL F.READ(FN.REDO.SC.MM.VERSION.PARAM,Y.VERSION,R.REDO.SC.MM.VERSION.PARAM,F.REDO.SC.MM.VERSION.PARAM,PAR.ERR)

        Y.CATEG = R.NEW(MM.CATEGORY)
        LOCATE Y.CATEG IN R.REDO.SC.MM.VERSION.PARAM<REDO.SMV.CATEGORY,1> SETTING POS ELSE
            ETEXT = 'EB-VERSION.DIFFERS'
            CALL STORE.END.ERROR
        END
    END

RETURN

END
