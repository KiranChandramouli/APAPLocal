SUBROUTINE REDO.V.AUTH.UPD.ALE.TFS
*---------------------------------------------------------------------------------
*This is an Authorisation routine for the version AC.LOCKED.EVENTS,INPUT it will lock
*the customer's account
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : GANESH R
* Program Name  : REDO.V.INP.GARNISHMENT.MAINT
* ODR NUMBER    : ODR-2009-10-0531
* HD REFERENCE  : HD1016159
*Routine Name   :REDO.V.AUTH.LOCK.ACCT
*LINKED WITH:
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
*MODIFICATION DETAILS:
* Date               By              HD ISSUE
* 16-10-2011        Prabhu.N         PACS00146120  Routine to post ofs message for AC.LOCKED.EVENTS
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.REDO.TFS.ALE
    GOSUB INIT
    GOSUB PROCESS
RETURN
INIT:
    FN.REDO.ALE.TFS='F.REDO.TFS.ALE'
    F.REDO.ALE.TFS=''
    CALL OPF(FN.REDO.ALE.TFS,F.REDO.ALE.TFS)
    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
RETURN

PROCESS:
    R.REDO.ALE.TFS<TFS.ALE.ALE>=ID.NEW
*    CALL F.READ(FN.AC.LOCKED.EVENTS,ID.NEW,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,ALE.ERR)
    Y.LCK.LOCKED.AMOUNT  = R.NEW(AC.LCK.LOCKED.AMOUNT)
    R.REDO.ALE.TFS<TFS.ALE.ALE.AMOUNT> = Y.LCK.LOCKED.AMOUNT
    Y.ID.ALE.TFS=R.NEW(AC.LCK.DESCRIPTION)
    CALL F.WRITE(FN.REDO.ALE.TFS,Y.ID.ALE.TFS,R.REDO.ALE.TFS)
RETURN
END
