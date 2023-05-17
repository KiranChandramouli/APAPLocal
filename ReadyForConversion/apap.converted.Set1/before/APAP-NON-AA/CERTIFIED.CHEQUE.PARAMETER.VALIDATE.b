*-----------------------------------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------------------------------
  SUBROUTINE CERTIFIED.CHEQUE.PARAMETER.VALIDATE
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the CERTIFIED.CHEQUE.PARAMETER table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : CERTIFIED.CHEQUE.PARAMETER.VALIDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*12.03.2010      SUDHARSANAN S      ODR-2009-10-0319 INITIAL CREATION
* -----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
  GOSUB PROCESS
  RETURN
PROCESS:
*********
*Checking the type of the certified cheque
  Y.TYPE.1 = R.NEW(CERT.CHEQ.TYPE)<1,1>
  Y.TYPE.2 = R.NEW(CERT.CHEQ.TYPE)<1,2>
  TYPE.COUNT= DCOUNT(R.NEW(CERT.CHEQ.TYPE),VM)
  IF TYPE.COUNT GT '2' THEN
    AF = CERT.CHEQ.TYPE
    AV = TYPE.COUNT
    ETEXT = "TT-CHEQUE.TYPE.COUNT"
    CALL STORE.END.ERROR
  END ELSE
    IF Y.TYPE.1 EQ Y.TYPE.2 THEN
      AF = CERT.CHEQ.TYPE
      AV = TYPE.COUNT
      ETEXT = "TT-CHEQUE.TYPE":FM:Y.TYPE.1
      CALL STORE.END.ERROR
    END
  END
  Y.CHEQUE.TYPE=R.NEW(CERT.CHEQ.TYPE)
  CONVERT VM TO FM IN Y.CHEQUE.TYPE
  LOCATE 'GOVT' IN Y.CHEQUE.TYPE SETTING POS1 THEN
    Y.SER.NO=R.NEW(CERT.CHEQ.START.SERIAL.NO)<1,POS1>
    IF Y.SER.NO NE 1 THEN
      AF = CERT.CHEQ.START.SERIAL.NO
      AV = POS1
      ETEXT = "TT-GOVT.CHEQUE"
      CALL STORE.END.ERROR
    END
  END
  LOCATE 'NON.GOVT' IN Y.CHEQUE.TYPE SETTING POS2 THEN
    Y.SER.NO=R.NEW(CERT.CHEQ.START.SERIAL.NO)<1,POS2>
    IF Y.SER.NO NE 2 THEN
      AF = CERT.CHEQ.START.SERIAL.NO
      AV = POS2
      ETEXT = "TT-NONGOVT.CHEQUE"
      CALL STORE.END.ERROR
    END
  END
  RETURN
*-----------------------------------------------------------------------------------------------------------------
END
