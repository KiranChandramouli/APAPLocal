SUBROUTINE REDO.APAP.GET.CHANGED.CUS
*-----------------------------------------------------------------------------
*DESCRIPTIONS:
*-------------
* It is Conversion Routine can be used when a multivalue field
* used to display in enquiry
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
**
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                 Reference
* 06-SEP-10    Kishore.SP            INITIALVERSION
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*---------------------------------------------------------------------------
*
    VM.COUNT = DCOUNT(O.DATA,@VM)
    O.DATA = O.DATA<1,VC>
RETURN
END
