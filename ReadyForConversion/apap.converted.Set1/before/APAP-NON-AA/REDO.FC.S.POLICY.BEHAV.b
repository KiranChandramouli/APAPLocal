*-----------------------------------------------------------------------------
* <Rating>-56</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.S.POLICY.BEHAV
*-----------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT.VALIDATE
* Attached as     : ROUTINE
* Primary Purpose : Get AND APPLY the behavior that need each field in a Policy
*                   as incoming parameter
*
* Incoming:
*-----------------------------------------------------------------------------
*
* Outgoing:
*-----------------------------------------------------------------------------
*
*
* Error Variables:
*-----------------------------------------------------------------------------
*
* Modification History:
*-----------------------------------------------------------------------------
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Marcelo Gudino - TAM Latin America
*                   Luis Pazmino   - TAM Latin America
* Date            : Julio 25 2011
*-----------------------------------------------------------------------------
*   DATE            WHO                DETAILS
*   22-05-2012   jvalarezo          clear a varible that will be store parameters
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STANDARD.SELECTION

$INSERT I_F.APAP.H.INSURANCE.CLASS.POLICY
$INSERT I_F.APAP.H.INSURANCE.COMB.PARAM
$INSERT I_F.APAP.H.INSURANCE.POLICY.TYPE
$INSERT I_F.APAP.H.INSURANCE.DETAILS
$INSERT I_F.REDO.APP.MAPPING
$INSERT I_F.REDO.CREATE.ARRANGEMENT
* </region>

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN

* <region name="INITIALISE">
INITIALISE:

  LOOP.CNT        =  0
  MAX.LOOPS       =  0
  PROCESS.GOAHEAD =  1

  APP.NAME        =  ''
  Y.APP.ERR       =  ''
  FIELD.NO        =  ''
  NO.OF.FIELDS    =  0
  FIELD.VALUE     =  ''
  FIELD.BEHAVIOUR =  ''
  NO.BEHAVIOUR    =  ''
  POLICY.TYPE     =  ''

  FN.CLASS.POLICY =  'F.APAP.H.INSURANCE.CLASS.POLICY'
  F.CLASS.POLICY  =  ''
  R.CLASS.POLICY  =  ''
  CLASS.POLICY    =  ''

  FN.POLICY.TYPE  =  'F.APAP.H.INSURANCE.POLICY.TYPE'
  F.POLICY.TYPE   =  ''
  R.POLICY.TYPE   =  ''
  POLICY.TYPE.ERR =  ''

  FN.INS.COMB     =  'F.APAP.H.INSURANCE.COMB.PARAM'
  F.INS.COMB      =  ''
  R.INS.COMB      =  ''
  ID.INS.COMB     =  ''
  INS.COMB.ERR    =  ''

  FN.REDO.APP.MAPPING = 'F.REDO.APP.MAPPING'
  F.REDO.APP.MAPPING = ''
  R.REDO.APP.MAPPING = ''

  Y.ERR = ''

  SEL.CMD         =  ''
  SEL.LIST        =  ''
  NO.OF.REC       =  0
  RET.CODE        =  ''

  ITR.FIELDS      =  0
  ITR.BEHAVIOUR   =  0
  FIELD.PREFIX    =  ''
  PRIORITY        =  0
  REVIEW          =  0
  R.BEHA.FLDS     =  ''
  AP.NAME         =  ''
  F.NAMED         =  ''

  FIELD.NAME      = ''
  FIELD.NAME.BEHA = ''
  FIELD.NAME.VALU = ''

  F.NAMED = ''
  F.NO  = 0

  RETURN
* </region>

* <region name="OPEN.FILES">
OPEN.FILES:
  CALL OPF(FN.CLASS.POLICY,F.CLASS.POLICY)
  CALL OPF(FN.POLICY.TYPE,F.POLICY.TYPE)
  CALL OPF(FN.INS.COMB,F.INS.COMB)
  CALL OPF(FN.REDO.APP.MAPPING,F.REDO.APP.MAPPING)

  RETURN
* </region>

* <region name="PROCESS">
PROCESS:
  Y.APP.NAME = APPLICATION
* Obtiene el numero de bloques MV que tiene que procesar por cada poliza ingresada
  Y.POLICY.TYPE  = 'INS.POLICY.TYPE'
  Y.CLASS.POLICY = 'CLASS.POLICY'

  CALL EB.FIND.FIELD.NO(Y.APP.NAME,Y.POLICY.TYPE)
  CALL EB.FIND.FIELD.NO(Y.APP.NAME,Y.CLASS.POLICY)
  Y.NUM.INS = DCOUNT(R.NEW(Y.POLICY.TYPE),VM)
  FOR I = 1 TO Y.NUM.INS
    POLICY.TYPE  = FIELD(R.NEW(Y.POLICY.TYPE),VM,I)
    CLASS.POLICY = FIELD(R.NEW(Y.CLASS.POLICY),VM,I)
    GOSUB APPLY.BEHAVIOUR
  NEXT I
  RETURN
* </region>

* <region name="APPLY.BEHAVIOUR">
APPLY.BEHAVIOUR:
  SEL.CMD  = 'SELECT ' : FN.INS.COMB : ' '
  SEL.CMD := 'WITH INS.POLICY.TYPE EQ ' : POLICY.TYPE
  SEL.CMD := ' AND INS.POLICY.CLASS EQ ': CLASS.POLICY
*JV 22052012 Clear variable will be store parameters
  R.INS.COMB = ''
  CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.REC,RET.CODE)

  IF NO.OF.REC GT 0 THEN
    LOOP
      REMOVE ID.INS.COMB FROM SEL.LIST SETTING ITR
    WHILE ID.INS.COMB:ITR
      CALL F.READ(FN.INS.COMB, ID.INS.COMB, R.INS.COMB, F.INS.COMB, Y.APP.ERR)
      IF Y.APP.ERR THEN
        ETEXT = "EB-FC-READ.ERROR" : FM : FN.INS.COMB
        CALL STORE.END.ERROR
      END

      IF R.INS.COMB NE '' THEN
        PRIORITY = 0
        AP.NAME = 'APAP.H.INSURANCE.COMB.PARAM'
        R.BEHA.FLDS = R.INS.COMB
        GOSUB SET.BEHAVIOUR
      END
    REPEAT
  END

  IF CLASS.POLICY NE '' THEN
    CALL F.READ(FN.CLASS.POLICY, CLASS.POLICY, R.CLASS.POLICY, F.CLASS.POLICY ,Y.APP.ERR)
    IF Y.APP.ERR THEN
      ETEXT = "EB-FC-READ.ERROR" : FM : FN.CLASS.POLICY
      CALL STORE.END.ERROR
    END

    IF R.CLASS.POLICY NE '' THEN
      PRIORITY = 2
      AP.NAME = 'APAP.H.INSURANCE.CLASS.POLICY'
      R.BEHA.FLDS = R.CLASS.POLICY
      GOSUB SET.BEHAVIOUR
    END
  END

  IF POLICY.TYPE NE '' THEN
    CALL F.READ(FN.POLICY.TYPE, POLICY.TYPE, R.POLICY.TYPE, F.POLICY.TYPE, Y.APP.ERR)
    IF Y.APP.ERR THEN
      ETEXT = "EB-FC-READ.ERROR" : FM : FN.POLICY.TYPE
      CALL STORE.END.ERROR
    END

    IF R.POLICY.TYPE NE '' THEN
      PRIORITY=1
      AP.NAME = 'APAP.H.INSURANCE.POLICY.TYPE'
      R.BEHA.FLDS = R.POLICY.TYPE
      GOSUB SET.BEHAVIOUR
    END
  END

  RETURN
* </region>

* <region name="CHECK.PRELIM.CONDITIONS">
CHECK.PRELIM.CONDITIONS:

  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1
    END CASE
    LOOP.CNT +=1
  REPEAT

  RETURN
* </region>

* <region name="SET.BEHAVIOUR">
SET.BEHAVIOUR:
  GOSUB GET.FIELDS.POS

  NO.OF.FIELDS = DCOUNT(R.BEHA.FLDS<FIELD.NAME>,VM)

  FOR ITR.FIELDS = 1 TO NO.OF.FIELDS
    FIELD.NO = R.BEHA.FLDS<FIELD.NAME,ITR.FIELDS>
    F.NAMED  = R.BEHA.FLDS<FIELD.NAME,ITR.FIELDS>
    IF PRIORITY EQ 1 OR PRIORITY EQ 2 THEN
      LOCATE FIELD.NO IN R.INS.COMB<INS.COMB.PARAM.FIELD.NAME,1> SETTING POS THEN
        REVIEW = 1
      END ELSE
        REVIEW = 0
      END
    END

    IF REVIEW EQ 0 THEN
      CALL EB.GET.APPL.FIELD(APP.NAME,FIELD.NO,'',Y.APP.ERR)
      NO.BEHAVIOUR = DCOUNT(R.BEHA.FLDS<FIELD.NAME.BEHA,ITR.FIELDS>,SM)

      FOR ITR.BEHAVIOUR = 1 TO NO.BEHAVIOUR
        FIELD.BEHAVIOUR = R.BEHA.FLDS<FIELD.NAME.BEHA,ITR.FIELDS,ITR.BEHAVIOUR>
        FIELD.VALUE     = R.BEHA.FLDS<FIELD.NAME.VALU,ITR.FIELDS,ITR.BEHAVIOUR>
* Mapeo REDO.CREATE.ARRANGEMENT
* Se utilizo REDO.APP.MAPPING en reemplazo de REDO.FC.S.INS.MAPING
* lfpazmino
* 20.7.2011
        GOSUB PROCESS.RCA.FIELDS
      NEXT ITR.BEHAVIOUR
    END

  NEXT ITR.FIELDS

  RETURN
* </region>

* <region name="GET.FIELDS.POS">
GET.FIELDS.POS:

  FIELD.NAME      = 'FIELD.NAME'
  FIELD.NAME.BEHA = 'FIELD.BEHA'
  FIELD.NAME.VALU = 'FIELD.VALUES'

  CALL EB.GET.APPL.FIELD(AP.NAME,FIELD.NAME,'',Y.APP.ERR)
  CALL EB.GET.APPL.FIELD(AP.NAME,FIELD.NAME.BEHA,'',Y.APP.ERR)
  CALL EB.GET.APPL.FIELD(AP.NAME,FIELD.NAME.VALU,'',Y.APP.ERR)

  RETURN
* </region>

* <region name="PROCESS.RCA.FIELDS">
PROCESS.RCA.FIELDS:

  Y.INS.MAPPING = 'INS-RECORDS'
  CALL CACHE.READ(FN.REDO.APP.MAPPING,Y.INS.MAPPING,R.REDO.APP.MAPPING,Y.ERR)

  Y.NUM.FIELDS = DCOUNT(R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>, VM)
  Y.APP.FROM   = FIELD(R.REDO.APP.MAPPING<REDO.APP.APP.FROM>,VM,1)
  Y.SV.FLAG =  FIELD(F.NAMED,"-",2)
  LOCATE F.NAMED IN R.REDO.APP.MAPPING<REDO.APP.FIELD.TO,1> SETTING POS THEN
* Verifique si el campo encontrado tiene subvalores o no
* de ser asi aplique el behaviour a cada subvalor
    Y.FIELD = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,VM,POS)
    CALL EB.FIND.FIELD.NO(Y.APP.FROM,Y.FIELD)
    Y.NUM.SV = DCOUNT(R.NEW(Y.FIELD)<1,I>, SM)

    IF Y.NUM.SV EQ 0 THEN
      IF Y.SV.FLAG EQ 1 THEN
        Y.NUM.SV = 1
      END
      ELSE
        Y.NUM.SV = ''
      END
    END

    Y.FIELD.FROM = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,VM,POS)
    Y.FIELD.FROM.NAME = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,VM,POS)
    CALL EB.GET.APPL.FIELD(Y.APP.FROM,Y.FIELD.FROM,'',Y.APP.ERR)

    IF Y.NUM.SV NE '' THEN
      FOR J = 1 TO Y.NUM.SV
        IF Y.FIELD.FROM GT 0 THEN
* Apply behaviour
          CALL REDO.FC.S.FIELD.VALID.POL(Y.FIELD.FROM, FIELD.BEHAVIOUR, FIELD.VALUE, Y.FIELD.FROM.NAME, I, J)
        END
      NEXT J
    END ELSE
      CALL REDO.FC.S.FIELD.VALID.POL(Y.FIELD.FROM, FIELD.BEHAVIOUR, FIELD.VALUE, Y.FIELD.FROM.NAME, I, '')
    END

  END
  RETURN
* </region>

END
