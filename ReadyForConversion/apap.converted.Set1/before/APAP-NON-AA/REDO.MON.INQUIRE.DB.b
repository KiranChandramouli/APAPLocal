*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>740</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MON.INQUIRE.DB(P.VALIDATE.PROCESS,P.CONV.FUNCTION,P.CONV.PARAM)

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_RAPID.APP.DEV.COMMON
$INSERT I_F.STANDARD.SELECTION


  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN

*-----------------------------------------------------------------------------------
PROCESS:


  IF WE.ARE.VALIDATING THEN
*DEBUG
    CALL CACHE.READ(FN.SS,Y.APPLICATION,R.SS,ERR.SS)

    IF R.SS THEN
      LOCATE Y.APP.FIELD IN R.SS<SSL.SYS.FIELD.NAME,1> SETTING FLD.OK ELSE
        LOCATE Y.APP.FIELD IN R.SS<SSL.USR.FIELD.NAME,1> SETTING FLD.OK ELSE
          E = 'EB-RAD.INVALID.FIELD'
        END
      END
    END ELSE
      E = 'EB-RAD.INVALID.APPLICATION'
    END

    IF Y.DELIMITER EQ '' THEN
      E = 'EB-RAD.INVALID.DELIMITER'
    END

  END ELSE
*        DEBUG
    CALL CACHE.READ(FN.SS,Y.APPLICATION,R.SS,ERR.SS)

***FETCH.FIELD.NO

    FIELD.NO = Y.APP.FIELD
    FIELD.TYPE = 'D'

    IF R.SS THEN
      LOCATE Y.APP.FIELD IN R.SS<SSL.SYS.FIELD.NAME,1> SETTING FIELD.NAME.POS THEN
        FIELD.NO = R.SS<SSL.SYS.FIELD.NO,FIELD.NAME.POS>
        FIELD.TYPE = R.SS<SSL.SYS.TYPE,FIELD.NAME.POS>
      END ELSE
        LOCATE Y.APP.FIELD IN R.SS<SSL.USR.FIELD.NAME,1> SETTING FIELD.NAME.POS THEN
          POSSIBLE.FIELD.NO = R.SS<SSL.USR.FIELD.NO,FIELD.NAME.POS>
          IF POSSIBLE.FIELD.NO[1,9] EQ LOCAL.REF.FIELD.NAME THEN
            LOCATE LOCAL.REF.FIELD.NAME IN R.SS<SSL.SYS.FIELD.NAME,1> SETTING FIELD.NAME.POS THEN
              FIELD.NO = R.SS<SSL.SYS.FIELD.NO,FIELD.NAME.POS>
              FIELD.TYPE = R.SS<SSL.SYS.TYPE,FIELD.NAME.POS>
*                           FIELD.SV = FIELD.MV
              FIELD.MV = POSSIBLE.FIELD.NO['>',1,1]
              FIELD.MV = FIELD.MV[',',2,1]
            END
          END ELSE
            FIELD.NO = Y.APP.FIELD      ;* Its an IDESC.
            FIELD.TYPE = R.SS<SSL.USR.TYPE,FIELD.NAME.POS>
          END
        END ELSE
          NULL
        END
      END
    END

***FETCH.FIELD.VALUE

    BEGIN CASE
    CASE FIELD.NO # ''
      BEGIN CASE
      CASE FIELD.NO EQ 0
*               FIELD.VALUE = APP.ID
        FIELD.VALUE = ''
      CASE OTHERWISE
        REC = COMI
        CONVERT Y.DELIMITER TO FM IN REC

        IF FIELD.TYPE EQ 'D' THEN
          FIELD.VALUE = REC<FIELD.NO>
        END ELSE
          FIELD.VALUE = ''
*                   CALL IDESC(FN.APP,APP.ID,R.APP,FIELD.NAME,FIELD.VALUE)
        END
*
        BEGIN CASE
        CASE FIELD.MV AND FIELD.SV
          FIELD.VALUE = FIELD.VALUE<1,FIELD.MV,FIELD.SV>
        CASE FIELD.MV
          FIELD.VALUE = FIELD.VALUE<1,FIELD.MV>
        CASE FIELD.SV
          FIELD.VALUE = FIELD.VALUE<1,1,FIELD.SV>
        END CASE
      END CASE
      COMI = FIELD.VALUE
    CASE FIELD.NO EQ ''
      COMI = ''
    END CASE


    RETURN

*-----------------------------------------------------------------------------------
*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*

INITIALISE:

    PROCESS.GOAHEAD = 1
    WE.ARE.VALIDATING = P.VALIDATE.PROCESS EQ 'VALIDATE'

    Y.APPLICATION = P.CONV.PARAM[',',1,1]
    Y.APP.FIELD = P.CONV.PARAM[',',2,1]
    Y.DELIMITER = P.CONV.PARAM[',',3,1]

    LOCAL.REF.FIELD.NAME = 'LOCAL.REF'
    FIELD.MV = ''
    FIELD.SV = ''

    RETURN
*-----------------------------------------------------------------------------------
OPEN.FILES:
    FN.SS = 'F.STANDARD.SELECTION' ; F.SS = ''
    RETURN
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:

    RETURN
*-----------------------------------------------------------------------------------


  END












