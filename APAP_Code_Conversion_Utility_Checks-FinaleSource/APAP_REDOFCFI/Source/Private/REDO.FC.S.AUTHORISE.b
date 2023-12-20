* @ValidationCode : MjoxOTkxNjUwNDkyOkNwMTI1MjoxNzAyOTkwOTQ1MjM2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:32:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.AUTHORISE(RESULT)
    
*------------------------------------------------------------------------------------------------------------------
* Developer    : mgudino@temenos.com
* Date         : 2011-06-13
* Description  : Manage the Authorise Routines
*
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
*      P.FIELD.NAME              Name of field that we have tu validate
*      R.NEW                     Common Variable with current Application Info
* Out :
*      P.MESSAGE                  Message to send by pharent call.
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.0              2011-06-13    Marcelo Gudi      First Version
* 2.0              2011-08-27    JP                Second Version
* 3.0              2011-11-10    lfpazmino         Minor Fixes (empty 'E' one is used)
*------------------------------------------------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 04-APRIL-2023      Harsha                R22 Auto Conversion  - VM to @VM
* 04-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
* 15-12-2023      VIGNESHWARI               R22 Manual Conversion - CALL RTN MODIFIED, OPF IS ADDED
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON
    $INSERT I_F.REDO.FC.BH.VALIDATIONS
    $USING EB.TransactionControl

    GOSUB INITIALISE
    GOSUB OPENFILES

    GOSUB PROCESS

RETURN

*------------------------------------------------------------------------------------------------------------------
PROCESS:
*--------------
*

    Y.VERSION.NAME = SUBSTRINGS (Y.VERSION.NAME, 2, Y.COUNT.VERSION)
    CALL CACHE.READ(FN.REDO.FC.BH.VALIDATIONS, Y.VERSION.NAME, R.REDO.FC.BH.VALIDATIONS, Y.ERR)
    IF Y.ERR THEN
* JP20110827
* Si no encuentra la parametrizacion correspondiente solo autoriza el registro
        RETURN
    END
* Recupera el numero de Rutinas parametrizadas
    Y.COUNT.VAL = DCOUNT(R.REDO.FC.BH.VALIDATIONS<REDO.BH.NAME.RUTINE>,@VM)

*_Inicia Bucle
    FOR CONT.RTNS = 1 TO Y.COUNT.VAL
        Y.RUTINE.NAME = R.REDO.FC.BH.VALIDATIONS<REDO.BH.NAME.RUTINE,CONT.RTNS>
        IF Y.RUTINE.NAME THEN
* Llamada a las rutinas parametrizadas
            Y.RESULT = ''
            CALL @Y.RUTINE.NAME(Y.RESULT)
            RESULT = Y.RESULT

* Control de Errores
            IF RESULT EQ 'FAIL' THEN
*Si una de las transacciones falla => se cancela la transaccion actual
                ETEXT = E
                E = ''
                CALL STORE.END.ERROR
*                CALL TRANSACTION.ABORT
                EB.TransactionControl.TransactionAbort()    ;*R22 Manual Conversion -CALL RTN MODIFIED
                RETURN
            END
        END
    NEXT

RETURN
*------------------------------------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------------------------------------
*
    YERR = ''
    Y.APP.NAME = ''
    Y.VERSION.NAME = PGM.VERSION:'.AUTH'
    Y.COUNT.VERSION = LEN(Y.VERSION.NAME)
    Y.RUTINE.NAME = ''
    Y.CONT.VAL = 0


    FN.REDO.FC.BH.VALIDATIONS = 'F.REDO.FC.BH.VALIDATIONS'
    F.REDO.FC.BH.VALIDATIONS = ''
    CALL OPF(FN.REDO.FC.BH.VALIDATIONS,F.REDO.FC.BH.VALIDATIONS)    ;* R22 Manual Conversion - OPF IS ADDED

RETURN

*------------------------------------------------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------------------------------------------------
* N/A
RETURN
*------------------------------------------------------------------------------------------------------------------
END
