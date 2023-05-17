SUBROUTINE REDO.IVR.RESP.TWS(Y.RESPONSE)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is a routine to simplify the TWS response for loan payments through IVR.
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*  10-JUL-2014   RMONDRAGON             ODR-2011-02-0099        INITIAL VERSION
*-----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
* </region>
*-----------------------------------------------------------------------------

    IF LNGG EQ 1 THEN
        Y.MSG = 'Operation cannot be processed'
    END ELSE
        Y.MSG = 'Operacion no puede ser procesada'
    END

    FINDSTR '//-1' IN Y.RESPONSE SETTING Y.POS THEN
        Y.RESPONSE = '<requests><request>//-1/NO,':Y.MSG:'</request></requests>'
    END ELSE
        FINDSTR '//1' IN Y.RESPONSE SETTING Y.POS THEN
            Y.FT.ID = FIELD(Y.RESPONSE,'/',1)
            Y.FT.ID = FIELD(Y.FT.ID,'<request>',2)
            Y.RESPONSE = '<requests><request>':Y.FT.ID:'//1/</request></requests>'
        END ELSE
            Y.RESPONSE = '<requests><request>//-1/NO,':Y.MSG:'</request></requests>'
        END
    END

RETURN

END
