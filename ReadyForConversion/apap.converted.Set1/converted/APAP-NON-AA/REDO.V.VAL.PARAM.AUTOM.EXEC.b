SUBROUTINE REDO.V.VAL.PARAM.AUTOM.EXEC
*------------------------------------------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.V.VAL.PARAM.AUTOM.EXEC
*Date              : 19.08.2010
*------------------------------------------------------------------------------------------------------------------
*Description:Routine  is used to validate AUTOM.EXEC Field in REDO.INTERFACE.PARAM,MAN Version
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : --N/A--
* Called By : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date              Name              Reference                    Version
* -------           ----              ----------                   --------
* 30.08.2010       Sakthi S          ODR-2010-03-0021             Initial Version
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.INTERFACE.PARAM
    IF COMI EQ 'SI' THEN
        T(REDO.INT.PARAM.AUTOM.EXEC.FREC)<3> = ''
    END ELSE
        T(REDO.INT.PARAM.AUTOM.EXEC.FREC)<3> = 'NOINPUT'
    END
RETURN
END
*----------------------------------------------------*END OF SUBROUTINE*-------------------------------------------
