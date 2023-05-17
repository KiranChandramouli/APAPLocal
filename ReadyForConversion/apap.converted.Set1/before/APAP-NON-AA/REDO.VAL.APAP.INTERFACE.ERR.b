*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.APAP.INTERFACE.ERR
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at Input Routines for Nomina files to Raise Errors
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : Riyas
* PROGRAM NAME : REDO.VAL.APAP.INTERFACE.ERR
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*       DATE             WHO                REFERENCE         DESCRIPTION
*------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
  Y.VERSION.LIST = ',NOMINAERR':VM:',BACENERR':VM:',ORANGERR'
  IF PGM.VERSION MATCHES Y.VERSION.LIST THEN
    ETEXT ='EB-INVALID.ACCT'
    CALL STORE.END.ERROR
  END
END
