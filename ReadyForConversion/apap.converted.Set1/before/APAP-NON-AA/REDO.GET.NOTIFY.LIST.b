*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.NOTIFY.LIST(Y.FINAL.ARRAY)

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.EB.LOOKUP
$INSERT I_ENQUIRY.COMMON

  virtualTableName = 'L.AC.NOTIFY.1'

  FN.EB.LOOKUP = 'F.EB.LOOKUP'
  F.EB.LOOKUP = ''
  CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

  SEL.CMD = 'SELECT ':FN.EB.LOOKUP:' WITH @ID LIKE ':virtualTableName:'*...'
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.ARR)

  LOOP
    REMOVE LOOKUP.ID FROM SEL.LIST SETTING LOOKUP.POS
  WHILE LOOKUP.ID:LOOKUP.POS

    CALL F.READ(FN.EB.LOOKUP,LOOKUP.ID,R.LOOKUP,F.EB.LOOKUP,LOOKUP.ERR)
    Y.GET.DESC = R.LOOKUP<EB.LU.DESCRIPTION,2>

    IF Y.GET.DESC EQ '' THEN
      Y.GET.DESC = R.LOOKUP<EB.LU.DESCRIPTION,1>
    END

    Y.FINAL.ARRAY<-1> =  FIELD(LOOKUP.ID,'*',2):'*':Y.GET.DESC
    Y.GET.DESC = ''
  REPEAT

  RETURN
