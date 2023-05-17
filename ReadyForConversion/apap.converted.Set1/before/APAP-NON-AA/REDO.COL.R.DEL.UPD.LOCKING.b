*-----------------------------------------------------------------------------
* <Rating>-96</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.COL.R.DEL.UPD.LOCKING(Y.OPTION, Y.RESPONSE)
*-----------------------------------------------------------------------------
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package redo.col
* Related with the service REDO.COL.DELIVERY, allows to manage the logic related
* with F.LOCKING
* Parameters:
* -----------------------
*                    Y.OPTION (in)    - CREATE, try to create the tracer record in locking
*                                       If the record is already used, then wait for the release
*                                     - READ, read the list of elements to process
*                                     - DELETE, delete the element from the list, bease was already processed
*                                       In this case Y.REPONSE has the entry to delete
*
*
*
* INPUT / OUTPUT
* -------------------------------
*                    E (Common)      Error message
*
* IF the extract process was not finished, then an error message on E variable is returned
*
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
* 14/09/2011 - PACS00110378         No leer la Cola REDO.COL.EXTRACT.CONTROL para determinar
*                                   si el proceso previo termino correctamente
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.COL.DELIVERY.COMMON
*-----------------------------------------------------------------------------

  GOSUB INITIALISE
  IF E NE '' THEN
    RETURN
  END
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

  Y.IS.LOCKED = '0'
*    LOOP
*        READU R.LOCKING FROM F.LOCKING,Y.LOCKING.ID LOCKED
*            Y.IS.LOCKED = '1'
* wait ONE second and re-try
*            SLEEP 1
*        END THEN
*            Y.IS.LOCKED = '0'
*        END ELSE
*            Y.IS.LOCKED = '0'
*        END

*    WHILE Y.IS.LOCKED EQ '1'
*    REPEAT
  READU R.LOCKING FROM F.LOCKING,Y.LOCKING.ID ELSE
 

  END
  BEGIN CASE
  CASE Y.OPTION EQ "READ"     ;* Just take the list to process
*    Y.RESPONSE = R.LOCKING<1>
*    Tus Start
     Y.RESPONSE = R.LOCKING<EB.LOK.CONTENT>
*    Tus End
    Y.RESPONSE = CHANGE(Y.RESPONSE, VM, FM)

  CASE Y.OPTION EQ "DELETE"   ;* Element was processed, then delete the entry from the tracer
*    Tus Start
*    Y.TO.SEARCH = R.LOCKING<1>
     Y.TO.SEARCH = R.LOCKING<EB.LOK.CONTENT>
*    Tus End
    LOCATE Y.RESPONSE IN  Y.TO.SEARCH<1,1> SETTING Y.POS THEN
*      DEL R.LOCKING<1,Y.POS>
*      Tus Start
       DEL R.LOCKING<EB.LOK.CONTENT,Y.POS>
*      Tus End
    END ELSE
      E = "ELEMENT & ALREADY PROCESSED"
      E<2> = Y.RESPONSE
    END
    WRITE R.LOCKING TO F.LOCKING,Y.LOCKING.ID
 


* Record does no existe try to create
  CASE Y.OPTION EQ "CREATE"

    GOSUB TABLE.PROCESS
* Create the Tracer Record
*    R.LOCKING<1> = ""
*    R.LOCKING<1> := "TMPCLIENTES" : VM : "TMPDIRECCIONESCLIENTE" : VM : "TMPTELEFONOSCLIENTE"
*    R.LOCKING<1> := VM : "TMPCREDITO" : VM : "TMPMOVIMIENTOS"
*    R.LOCKING<2> = "Trace for delivery process on Collector " : TIMEDATE()
*   Tus Start
    R.LOCKING<EB.LOK.CONTENT> = ""
    R.LOCKING<EB.LOK.CONTENT> := "TMPCLIENTES" : VM : "TMPDIRECCIONESCLIENTE" : VM : "TMPTELEFONOSCLIENTE"
    R.LOCKING<EB.LOK.CONTENT> := VM : "TMPCREDITO" : VM : "TMPMOVIMIENTOS"
    R.LOCKING<EB.LOK.REMARK> = "Trace for delivery process on Collector " : TIMEDATE()
*   Tus End
    Y.RESPONSE = ""


    NUM.TABLES  = DCOUNT(R.REDO.COL.MSG.QUEUE<1>,VM)
    FOR I = NUM.TABLES TO 1 STEP -1
*     Tus Start
*     LOCATE R.REDO.COL.MSG.QUEUE<1,I> IN R.LOCKING<1,1> SETTING Y.POS THEN
      LOCATE R.REDO.COL.MSG.QUEUE<1,I> IN R.LOCKING<EB.LOK.CONTENT,1> SETTING Y.POS THEN
*     DEL R.LOCKING<1,Y.POS>
      DEL R.LOCKING<EB.LOK.CONTENT,Y.POS>
*     Tus End
      END
    NEXT I
    WRITE R.LOCKING TO F.LOCKING,Y.LOCKING.ID     ;* mmm, seems to be an error, the record was not created yet
 

  CASE 1
    E = "RECORD " : Y.LOCKING.ID : "DOES NO EXISTS"
  END CASE

* IF Y.IS.LOCKED EQ '1' THEN
  RELEASE F.LOCKING, Y.LOCKING.ID
 
* END

  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
  Y.LOCKING.ID = K.COL.DELIVERY.TRACE.ID : '-' : TODAY
  R.LOCKING = ''

  R.REDO.COL.MSG.QUEUE=""
  FN.REDO.COL.MSG.QUEUE='F.REDO.MSG.COL.QUEUE'
  F.REDO.COL.MSG.QUEUE = ''
  CALL OPF(FN.REDO.COL.MSG.QUEUE,F.REDO.COL.MSG.QUEUE)


  RETURN
*------------------------------------------
TABLE.PROCESS:
*------------------------------------------

  NO.REC.CLI=0
  NO.REC.PHON=0
  NO.REC.DIR=0
  NO.REC.MOV=0
  NO.REC.CRE=0

  Y.TABLE=""
  C.TABLES=""

  C.TABLES<-1>='TMPCLIENTES'
  C.TABLES<-1>='TMPTELEFONOSCLIENTE'
  C.TABLES<-1>='TMPDIRECCIONESCLIENTE'
  C.TABLES<-1>='TMPMOVIMIENTOS'
  C.TABLES<-1>='TMPCREDITO'

  LOOP
    REMOVE Y.TABLE FROM C.TABLES SETTING Y.POS
  WHILE Y.TABLE
    GOSUB CHECK.PROCESS.CONTINUE
    IF NO.REC.SEL GT 0 AND Y.TABLE EQ "TMPCLIENTES" THEN
      R.REDO.COL.MSG.QUEUE<1,1>=Y.TABLE
    END

    IF NO.REC.SEL GT 0 AND Y.TABLE EQ "TMPTELEFONOSCLIENTE" THEN
      R.REDO.COL.MSG.QUEUE<1,2>=Y.TABLE
    END

    IF NO.REC.SEL GT 0 AND Y.TABLE EQ "TMPDIRECCIONESCLIENTE" THEN
      R.REDO.COL.MSG.QUEUE<1,3>=Y.TABLE
    END

    IF NO.REC.SEL GT 0 AND Y.TABLE EQ "TMPMOVIMIENTOS" THEN
      R.REDO.COL.MSG.QUEUE<1,4>=Y.TABLE
    END

    IF NO.REC.SEL GT 0 AND Y.TABLE EQ "TMPCREDITO" THEN
      R.REDO.COL.MSG.QUEUE<1,5>=Y.TABLE
    END
  REPEAT

  Y.MSG="Tablas - ":R.REDO.COL.MSG.QUEUE
  CALL OCOMO(Y.MSG)

  RETURN
*======================
CHECK.PROCESS.CONTINUE:
*======================

  Y.SELECT.TABLES=""
  Y.SELECT.TABLES :   = 'SELECT ':FN.REDO.COL.MSG.QUEUE
  Y.SELECT.TABLES := ' WITH @ID LIKE ':Y.TABLE:'.':TODAY:'.':ID.COMPANY:"..."
  Y.ERR=''
  Y.F.REDO.MSG.QUEUE=''
  Y.LIST.MSG=''

  CALL EB.READLIST(Y.SELECT.TABLES,Y.F.REDO.MSG.QUEUE,Y.LIST.MSG,NO.REC.SEL,Y.ERR)


  RETURN
*------------------------------------------------------------------------------------------
END
