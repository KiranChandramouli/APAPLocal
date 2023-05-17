SUBROUTINE MB.SDB.MAINT.FIELDS
*----------------------------------------------------------------------------
*** FIELD definitions FOR TEMPLATE
*!
* @author kbrindha@temenos.com
* @stereotype fields
* @uses C_METHODS
* @uses C_PROPERTIES
* @package infra.eb
*-----------------------------------------------------------------------------
* Revision History:
*------------------
* Date               who           Reference            Description
* 05/02/2009      K.BRINDHA                        Changed to R07 Template
*-----------------------------------------------------------------------------
* Modification History :
* dd/mm/yyy    - CD_REFERENCE - author
*              Description of modification. Why, what and who.
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_METHODS.AND.PROPERTIES

    GOSUB INITIALISE
    GOSUB DEFINE.FIELDS
RETURN

*** </region>
*-----------------------------------------------------------------------------
DEFINE.FIELDS:
    ID.F = 'SDB.ACTION' ; ID.N = '2.2' ;ID.T = '' ;
    Z = 0
    Z +=1 ; F(Z) = 'XX.DESCRIPTION' ; N(Z) = '65.2' ; T(Z) = 'A' ;
    Z+=1 ; F(Z) = "XX.LOCAL.REF" ; N(Z) = "35" ; T(Z) = ""
    Z +=1 ; F(Z) = 'RESERVED.10' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.9' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.8' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.7' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.6' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.5' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.4' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.3' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.2' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z +=1 ; F(Z) = 'RESERVED.1' ; N(Z) = '35' ; T(Z)='A'; T(Z)<3>='NOINPUT'
    Z+=1 ; F(Z) = "XX.OVERRIDE" ; N(Z) = "35" ; T(Z) = "A" ; T(Z)<3>='NOINPUT'
*-----------------------------------------------------------------------------
    V = Z + 9
RETURN
*-----------------------------------------------------------------------------
*** <region name= Initialise>
*** <desc>Create virtual tables and define check files</desc>
INITIALISE:
    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
* TODO define common checkfile field enrichments
*-----------------------------------------------------------------------------
* An example of how to use the EB.LOOKUP virtual tables
* TODO Define virtual tables
    VIRTUAL.TABLE.LIST = ''
RETURN
*** </region>
*-----------------------------------------------------------------------------
END
